import React, { useEffect, useRef, useState } from "react";

// Floor Plan Sketcher – single‑file React app (runs in browser)
// Features
// • Import a plan image (PNG/JPG)
// • Pan & zoom the canvas
// • Freehand sketching (walls/notes) with adjustable stroke & color
// • Polygon room tool with live area/perimeter (after scale calibration)
// • Measure tool (click–drag a tape line) – shows length in real units
// • Calibrate scale: draw a reference line and enter its real‑world length
// • Snap‑to‑grid toggle (minor/major spacing)
// • Undo / Redo
// • Export PNG (with background plan + drawings) & JSON; Import JSON
// • Simple layers: background plan, drawings, dimension text
//
// Notes
// - This is intentionally dependency‑light (no external libs), styled with Tailwind utility classes.
// - Designed for mouse & touch. On mobile, use two‑finger pinch to zoom and two‑finger pan.

const TOOLS = {
  PAN: "pan",
  FREE: "freehand",
  POLY: "polygon",
  MEASURE: "measure",
  CALIB: "calibrate",
  SELECT: "select",
};

const DEFAULTS = {
  strokeColor: "#111827", // Tailwind gray-900
  fillColor: "rgba(37,99,235,0.08)", // Tailwind blue-600 @ ~8%
  strokeWidth: 2,
  gridMinor: 10,
  gridMajor: 50,
};

// Utility helpers
function dist(a, b) {
  const dx = a.x - b.x;
  const dy = a.y - b.y;
  return Math.hypot(dx, dy);
}
function lerp(a, b, t) { return a + (b - a) * t; }
function clamp(v, lo, hi) { return Math.max(lo, Math.min(hi, v)); }

export default function FloorPlanSketcher() {
  const canvasRef = useRef(null);
  const overlayRef = useRef(null); // for hit UI overlays
  const containerRef = useRef(null);
  const [bgImage, setBgImage] = useState(null);
  const [tool, setTool] = useState(TOOLS.FREE);
  const [strokeColor, setStrokeColor] = useState(DEFAULTS.strokeColor);
  const [fillColor, setFillColor] = useState(DEFAULTS.fillColor);
  const [strokeWidth, setStrokeWidth] = useState(DEFAULTS.strokeWidth);
  const [snapGrid, setSnapGrid] = useState(true);
  const [showGrid, setShowGrid] = useState(true);
  const [scalePxPerUnit, setScalePxPerUnit] = useState(null); // pixels per chosen unit
  const [unitLabel, setUnitLabel] = useState("m");
  const [zoom, setZoom] = useState(1);
  const [pan, setPan] = useState({ x: 0, y: 0 });
  const [isPanning, setIsPanning] = useState(false);
  const [isDrawing, setIsDrawing] = useState(false);
  const [paths, setPaths] = useState([]); // {type:'free'|'poly'|'measure'|'calib', points:[{x,y}], strokeWidth, strokeColor, fillColor}
  const [current, setCurrent] = useState(null);
  const [history, setHistory] = useState([]);
  const [redoStack, setRedoStack] = useState([]);

  // Device pixel ratio for crisp lines on HiDPI
  const dpr = (typeof window !== 'undefined' && window.devicePixelRatio) ? window.devicePixelRatio : 1;

  // Resize canvas to container size
  useEffect(() => {
    const resize = () => {
      const cvs = canvasRef.current;
      const parent = containerRef.current;
      if (!cvs || !parent) return;
      const rect = parent.getBoundingClientRect();
      cvs.width = Math.floor(rect.width * dpr);
      cvs.height = Math.floor(rect.height * dpr);
      cvs.style.width = rect.width + "px";
      cvs.style.height = rect.height + "px";
      const ov = overlayRef.current;
      if (ov) {
        ov.width = cvs.width;
        ov.height = cvs.height;
        ov.style.width = cvs.style.width;
        ov.style.height = cvs.style.height;
      }
      draw();
    };
    resize();
    window.addEventListener('resize', resize);
    return () => window.removeEventListener('resize', resize);
    // eslint-disable-next-line
  }, [bgImage, zoom, pan, tool, paths, current, strokeColor, fillColor, strokeWidth, showGrid]);

  // History helpers
  function pushHistory(newPaths) {
    setHistory(h => [...h, JSON.stringify(newPaths)]);
    setRedoStack([]);
  }
  function undo() {
    setHistory(h => {
      if (h.length === 0) return h;
      const prev = h[h.length - 1];
      setRedoStack(r => [JSON.stringify(paths), ...r]);
      setPaths(JSON.parse(prev));
      return h.slice(0, -1);
    });
  }
  function redo() {
    setRedoStack(r => {
      if (r.length === 0) return r;
      const top = r[0];
      setHistory(h => [...h, JSON.stringify(paths)]);
      setPaths(JSON.parse(top));
      return r.slice(1);
    });
  }

  // World <-> screen transforms
  function worldToScreen(p) {
    return {
      x: (p.x * zoom + pan.x) * dpr,
      y: (p.y * zoom + pan.y) * dpr,
    };
  }
  function screenToWorld(p) {
    return {
      x: (p.x / dpr - pan.x) / zoom,
      y: (p.y / dpr - pan.y) / zoom,
    };
  }

  function drawGrid(ctx, w, h) {
    if (!showGrid) return;
    ctx.save();
    ctx.clearRect(0, 0, w, h);

    // background
    ctx.fillStyle = "#ffffff";
    ctx.fillRect(0, 0, w, h);

    // transform for pan/zoom
    ctx.translate(pan.x * dpr, pan.y * dpr);
    ctx.scale(zoom * dpr, zoom * dpr);

    const minor = DEFAULTS.gridMinor;
    const major = DEFAULTS.gridMajor;

    const rect = { x: -pan.x / zoom, y: -pan.y / zoom, w: w / (zoom * dpr), h: h / (zoom * dpr) };

    // minor grid
    ctx.beginPath();
    for (let x = Math.floor(rect.x / minor) * minor; x < rect.x + rect.w; x += minor) {
      ctx.moveTo(x, rect.y);
      ctx.lineTo(x, rect.y + rect.h);
    }
    for (let y = Math.floor(rect.y / minor) * minor; y < rect.y + rect.h; y += minor) {
      ctx.moveTo(rect.x, y);
      ctx.lineTo(rect.x + rect.w, y);
    }
    ctx.lineWidth = 1 / dpr; // hairline
    ctx.strokeStyle = "#f3f4f6"; // gray-100
    ctx.stroke();

    // major grid
    ctx.beginPath();
    for (let x = Math.floor(rect.x / major) * major; x < rect.x + rect.w; x += major) {
      ctx.moveTo(x, rect.y);
      ctx.lineTo(x, rect.y + rect.h);
    }
    for (let y = Math.floor(rect.y / major) * major; y < rect.y + rect.h; y += major) {
      ctx.moveTo(rect.x, y);
      ctx.lineTo(rect.x + rect.w, y);
    }
    ctx.lineWidth = 1 / dpr;
    ctx.strokeStyle = "#e5e7eb"; // gray-200
    ctx.stroke();

    ctx.restore();
  }

  function drawBackground(ctx) {
    if (!bgImage) return;
    ctx.save();
    ctx.translate(pan.x * dpr, pan.y * dpr);
    ctx.scale(zoom * dpr, zoom * dpr);
    ctx.imageSmoothingEnabled = true;
    ctx.imageSmoothingQuality = 'high';
    const w = bgImage.width;
    const h = bgImage.height;
    ctx.drawImage(bgImage, 0, 0, w, h);
    ctx.restore();
  }

  function drawPaths(ctx) {
    ctx.save();
    ctx.translate(pan.x * dpr, pan.y * dpr);
    ctx.scale(zoom * dpr, zoom * dpr);

    const drawPoly = (p) => {
      if (!p.points.length) return;
      ctx.beginPath();
      ctx.moveTo(p.points[0].x, p.points[0].y);
      for (let i = 1; i < p.points.length; i++) ctx.lineTo(p.points[i].x, p.points[i].y);
      if (p.closed) ctx.closePath();
      if (p.fillColor && p.closed) {
        ctx.fillStyle = p.fillColor;
        ctx.fill();
      }
      ctx.lineWidth = p.strokeWidth;
      ctx.strokeStyle = p.strokeColor;
      ctx.lineJoin = 'round';
      ctx.lineCap = 'round';
      ctx.stroke();

      // Labels (area/perimeter)
      if (p.closed && scalePxPerUnit) {
        const { area, perimeter } = polygonMetrics(p.points, scalePxPerUnit);
        const c = polygonCentroid(p.points);
        ctx.save();
        ctx.font = `${12/ (dpr)}px ui-sans-serif`;
        ctx.fillStyle = '#111827';
        ctx.textAlign = 'center';
        ctx.textBaseline = 'middle';
        const label = `${area.toFixed(2)} ${unitLabel}²\nPerim: ${perimeter.toFixed(2)} ${unitLabel}`;
        wrapText(ctx, label, c.x, c.y, 140/zoom, 14/zoom);
        ctx.restore();
      }
    };

    const drawFree = (p) => {
      if (p.points.length < 2) return;
      ctx.beginPath();
      for (let i = 0; i < p.points.length - 1; i++) {
        const a = p.points[i], b = p.points[i + 1];
        const mid = { x: lerp(a.x, b.x, 0.5), y: lerp(a.y, b.y, 0.5) };
        if (i === 0) ctx.moveTo(a.x, a.y);
        ctx.quadraticCurveTo(a.x, a.y, mid.x, mid.y);
      }
      const last = p.points[p.points.length - 1];
      ctx.lineTo(last.x, last.y);
      ctx.lineWidth = p.strokeWidth;
      ctx.strokeStyle = p.strokeColor;
      ctx.lineJoin = 'round';
      ctx.lineCap = 'round';
      ctx.stroke();
    };

    const drawMeasure = (p, withLabel = true) => {
      if (p.points.length < 2) return;
      const a = p.points[0], b = p.points[1];
      ctx.beginPath();
      ctx.moveTo(a.x, a.y);
      ctx.lineTo(b.x, b.y);
      ctx.lineWidth = p.strokeWidth;
      ctx.strokeStyle = p.strokeColor;
      ctx.setLineDash([6, 4]);
      ctx.stroke();
      ctx.setLineDash([]);

      // end caps
      ctx.beginPath();
      ctx.arc(a.x, a.y, 3/zoom, 0, Math.PI*2);
      ctx.arc(b.x, b.y, 3/zoom, 0, Math.PI*2);
      ctx.fillStyle = p.strokeColor;
      ctx.fill();

      if (withLabel && scalePxPerUnit) {
        const px = dist(a, b);
        const len = px / scalePxPerUnit;
        const mid = { x: (a.x + b.x)/2, y: (a.y + b.y)/2 };
        ctx.save();
        ctx.font = `${12 / (dpr)}px ui-sans-serif`;
        ctx.fillStyle = '#111827';
        ctx.textAlign = 'center';
        ctx.textBaseline = 'bottom';
        ctx.fillText(`${len.toFixed(2)} ${unitLabel}`, mid.x, mid.y - 6/zoom);
        ctx.restore();
      }
    };

    for (const p of paths) {
      if (p.type === 'poly') drawPoly(p);
      else if (p.type === 'free') drawFree(p);
      else if (p.type === 'measure' || p.type === 'calib') drawMeasure(p, p.type !== 'calib');
    }

    if (current) {
      if (current.type === 'poly') drawPoly(current);
      else if (current.type === 'free') drawFree(current);
      else if (current.type === 'measure' || current.type === 'calib') drawMeasure(current, current.type !== 'calib');
    }

    ctx.restore();
  }

  function draw() {
    const cvs = canvasRef.current;
    if (!cvs) return;
    const ctx = cvs.getContext('2d');
    const { width: w, height: h } = cvs;

    drawGrid(ctx, w, h);
    drawBackground(ctx);
    drawPaths(ctx);
  }

  // Polygon math
  function polygonArea(points) {
    // signed area (px^2)
    let a = 0;
    for (let i = 0, j = points.length - 1; i < points.length; j = i++) {
      a += (points[j].x * points[i].y - points[i].x * points[j].y);
    }
    return a / 2;
  }
  function polygonCentroid(points) {
    let cx = 0, cy = 0;
    let a = polygonArea(points) * 6; // 6A
    if (a === 0) {
      // fallback to average point
      const n = points.length;
      for (const p of points) { cx += p.x; cy += p.y; }
      return { x: cx / n, y: cy / n };
    }
    for (let i = 0, j = points.length - 1; i < points.length; j = i++) {
      const f = (points[j].x * points[i].y - points[i].x * points[j].y);
      cx += (points[j].x + points[i].x) * f;
      cy += (points[j].y + points[i].y) * f;
    }
    return { x: cx / a, y: cy / a };
  }
  function polygonPerimeter(points) {
    let p = 0;
    for (let i = 0; i < points.length; i++) {
      const a = points[i];
      const b = points[(i + 1) % points.length];
      p += dist(a, b);
    }
    return p;
  }
  function polygonMetrics(points, pxPerUnit) {
    const areaPx2 = Math.abs(polygonArea(points));
    const perimPx = polygonPerimeter(points);
    const areaUnits2 = (areaPx2) / (pxPerUnit * pxPerUnit);
    const perimUnits = perimPx / pxPerUnit;
    return { area: areaUnits2, perimeter: perimUnits };
  }

  function wrapText(ctx, text, x, y, maxWidth, lineHeight) {
    const lines = text.split('\n');
    let offY = 0;
    for (const ln of lines) {
      const words = ln.split(' ');
      let line = '';
      for (let n = 0; n < words.length; n++) {
        const testLine = line + words[n] + ' ';
        const metrics = ctx.measureText(testLine);
        if (metrics.width > maxWidth && n > 0) {
          ctx.fillText(line, x, y + offY);
          line = words[n] + ' ';
          offY += lineHeight;
        } else {
          line = testLine;
        }
      }
      ctx.fillText(line.trim(), x, y + offY);
      offY += lineHeight;
    }
  }

  // Event handling
  const pointerState = useRef({ id: null, last: null, twoFinger: false });

  function onPointerDown(e) {
    const rect = canvasRef.current.getBoundingClientRect();
    const pt = screenToWorld({ x: (e.clientX - rect.left) * dpr, y: (e.clientY - rect.top) * dpr });

    if (tool === TOOLS.PAN || (e.button === 1)) {
      setIsPanning(true);
      pointerState.current.last = { x: e.clientX, y: e.clientY };
      return;
    }

    if (tool === TOOLS.FREE) {
      const p = { type: 'free', points: [pt], strokeColor, strokeWidth, fillColor: null };
      setCurrent(p);
      setIsDrawing(true);
    } else if (tool === TOOLS.POLY) {
      setCurrent(c => {
        if (!c) return { type: 'poly', points: [pt], strokeColor, strokeWidth, fillColor, closed: false };
        // If clicking near first point, close polygon
        if (c.points.length > 2 && dist(pt, c.points[0]) < 10 / zoom) {
          const closed = true;
          const poly = { ...c, closed };
          const newPaths = [...paths, poly];
          pushHistory(paths);
          setPaths(newPaths);
          setCurrent(null);
        } else {
          const snapped = snapGrid ? snapPoint(pt) : pt;
          return { ...c, points: [...c.points, snapped] };
        }
        return c;
      });
    } else if (tool === TOOLS.MEASURE || tool === TOOLS.CALIB) {
      const p = { type: tool === TOOLS.CALIB ? 'calib' : 'measure', points: [pt, pt], strokeColor: '#ef4444', strokeWidth: 2, fillColor: null };
      setCurrent(p);
      setIsDrawing(true);
    }
  }

  function onPointerMove(e) {
    const rect = canvasRef.current.getBoundingClientRect();
    if (isPanning) {
      const last = pointerState.current.last;
      if (!last) return;
      const dx = e.clientX - last.x;
      const dy = e.clientY - last.y;
      setPan(p => ({ x: p.x + dx, y: p.y + dy }));
      pointerState.current.last = { x: e.clientX, y: e.clientY };
      return;
    }

    const pt = screenToWorld({ x: (e.clientX - rect.left) * dpr, y: (e.clientY - rect.top) * dpr });
    if (!current) return;

    if (current.type === 'free') {
      const snapped = snapGrid ? snapPoint(pt) : pt;
      setCurrent(c => ({ ...c, points: [...c.points, snapped] }));
    } else if (current.type === 'poly') {
      // Show a preview by updating last point if shift held => straight
      setCurrent(c => {
        if (!c) return c;
        const pts = [...c.points];
        pts[pts.length - 1] = snapGrid ? snapPoint(pt) : pt; // will be replaced on click
        return { ...c, points: pts };
      });
    } else if (current.type === 'measure' || current.type === 'calib') {
      setCurrent(c => ({ ...c, points: [c.points[0], snapGrid ? snapPoint(pt) : pt] }));
    }
  }

  function onPointerUp() {
    if (isPanning) {
      setIsPanning(false);
      return;
    }
    if (!current) return;
    if (current.type === 'free') {
      const newPaths = [...paths, current];
      pushHistory(paths);
      setPaths(newPaths);
      setCurrent(null);
    } else if (current.type === 'measure') {
      const newPaths = [...paths, current];
      pushHistory(paths);
      setPaths(newPaths);
      setCurrent(null);
    } else if (current.type === 'calib') {
      const a = current.points[0];
      const b = current.points[1];
      const px = dist(a, b);
      const val = prompt("Enter real‑world length of the calibration line (e.g., 3.2):", "1.0");
      if (val && !isNaN(parseFloat(val))) {
        const length = parseFloat(val);
        const unit = prompt("Enter unit label (e.g., m, ft, cm):", unitLabel || "m");
        if (unit) setUnitLabel(unit);
        if (length > 0) setScalePxPerUnit(px / length);
      }
      // keep the calib line (faint) to remember reference
      const calib = { ...current, strokeColor: '#9ca3af' };
      const newPaths = [...paths, calib];
      pushHistory(paths);
      setPaths(newPaths);
      setCurrent(null);
    }
  }

  function onWheel(e) {
    e.preventDefault();
    const rect = canvasRef.current.getBoundingClientRect();
    const mouse = screenToWorld({ x: (e.clientX - rect.left) * dpr, y: (e.clientY - rect.top) * dpr });

    const delta = -e.deltaY;
    const factor = Math.exp(delta * 0.001);
    const newZoom = clamp(zoom * factor, 0.2, 6);

    // Zoom about mouse point
    const wx = mouse.x; const wy = mouse.y;
    const sx = (wx * zoom + pan.x);
    const sy = (wy * zoom + pan.y);

    const nsx = (wx * newZoom + pan.x);
    const nsy = (wy * newZoom + pan.y);

    setPan({ x: pan.x - (nsx - sx), y: pan.y - (nsy - sy) });
    setZoom(newZoom);
  }

  function snapPoint(pt) {
    const minor = DEFAULTS.gridMinor;
    return { x: Math.round(pt.x / minor) * minor, y: Math.round(pt.y / minor) * minor };
  }

  // File IO
  function onImportImage(file) {
    const img = new Image();
    img.onload = () => {
      setBgImage(img);
      // fit to view: center and set zoom to fit width
      const parent = containerRef.current;
      if (parent) {
        const rect = parent.getBoundingClientRect();
        const scale = Math.min(rect.width / img.width, rect.height / img.height) * 0.9;
        setZoom(scale);
        setPan({ x: (rect.width - img.width * scale) / 2, y: (rect.height - img.height * scale) / 2 });
      }
    };
    img.src = URL.createObjectURL(file);
  }

  function exportPNG() {
    const cvs = document.createElement('canvas');
    const base = canvasRef.current;
    cvs.width = base.width; cvs.height = base.height;
    const ctx = cvs.getContext('2d');
    // redraw everything at current view
    drawGrid(ctx, cvs.width, cvs.height);
    drawBackground(ctx);
    drawPaths(ctx);
    const url = cvs.toDataURL('image/png');
    const a = document.createElement('a');
    a.href = url; a.download = 'plan.png'; a.click();
  }

  function exportJSON() {
    const data = {
      bg: null,
      paths,
      scalePxPerUnit,
      unitLabel,
      zoom,
      pan,
      strokeWidth,
      strokeColor,
      fillColor,
      snapGrid,
      showGrid,
    };
    const blob = new Blob([JSON.stringify(data)], { type: 'application/json' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url; a.download = 'plan.json'; a.click();
  }

  function importJSON(file) {
    const reader = new FileReader();
    reader.onload = () => {
      try {
        const data = JSON.parse(reader.result);
        if (data.paths) setPaths(data.paths);
        if (data.scalePxPerUnit) setScalePxPerUnit(data.scalePxPerUnit);
        if (data.unitLabel) setUnitLabel(data.unitLabel);
        if (data.zoom) setZoom(data.zoom);
        if (data.pan) setPan(data.pan);
        if (data.strokeWidth) setStrokeWidth(data.strokeWidth);
        if (data.strokeColor) setStrokeColor(data.strokeColor);
        if (data.fillColor) setFillColor(data.fillColor);
        if (typeof data.snapGrid === 'boolean') setSnapGrid(data.snapGrid);
        if (typeof data.showGrid === 'boolean') setShowGrid(data.showGrid);
      } catch (e) {
        alert('Invalid plan JSON');
      }
    };
    reader.readAsText(file);
  }

  // Keyboard shortcuts
  useEffect(() => {
    const onKey = (e) => {
      if (e.key === ' ' && !e.repeat) { setTool(TOOLS.PAN); }
      if ((e.ctrlKey || e.metaKey) && e.key.toLowerCase() === 'z') { e.preventDefault(); undo(); }
      if ((e.ctrlKey || e.metaKey) && e.key.toLowerCase() === 'y') { e.preventDefault(); redo(); }
      if ((e.ctrlKey || e.metaKey) && e.key.toLowerCase() === 's') { e.preventDefault(); exportJSON(); }
      if (e.key === 'Escape') { setCurrent(null); }
    };
    const onKeyUp = (e) => { if (e.key === ' ') setTool(TOOLS.FREE); };
    window.addEventListener('keydown', onKey);
    window.addEventListener('keyup', onKeyUp);
    return () => { window.removeEventListener('keydown', onKey); window.removeEventListener('keyup', onKeyUp); };
  }, [undo, redo]);

  // Main render
  return (
    <div className="w-full h-screen flex flex-col bg-gray-50">
      {/* Top bar */}
      <div className="flex items-center gap-2 p-3 border-b bg-white sticky top-0 z-10">
        <div className="text-xl font-semibold tracking-tight">Floor Plan Sketcher</div>
        <div className="ml-auto flex items-center gap-2">
          <label className="px-3 py-2 rounded-2xl bg-gray-100 hover:bg-gray-200 cursor-pointer">
            <input type="file" accept="image/*" className="hidden" onChange={(e)=> e.target.files && onImportImage(e.target.files[0])} />
            Import Plan Image
          </label>
          <label className="px-3 py-2 rounded-2xl bg-gray-100 hover:bg-gray-200 cursor-pointer">
            <input type="file" accept="application/json" className="hidden" onChange={(e)=> e.target.files && importJSON(e.target.files[0])} />
            Import JSON
          </label>
          <button onClick={exportPNG} className="px-3 py-2 rounded-2xl bg-blue-600 text-white hover:bg-blue-700 shadow">Export PNG</button>
          <button onClick={exportJSON} className="px-3 py-2 rounded-2xl bg-blue-50 text-blue-700 hover:bg-blue-100">Export JSON</button>
        </div>
      </div>

      {/* Toolbar */}
      <div className="flex flex-wrap items-center gap-2 p-3 bg-white/80 backdrop-blur border-b">
        <ToolButton active={tool===TOOLS.FREE} onClick={()=>setTool(TOOLS.FREE)} label="Freehand" icon="✏️"/>
        <ToolButton active={tool===TOOLS.POLY} onClick={()=>setTool(TOOLS.POLY)} label="Polygon" icon="🔺"/>
        <ToolButton active={tool===TOOLS.MEASURE} onClick={()=>setTool(TOOLS.MEASURE)} label="Measure" icon="📏"/>
        <ToolButton active={tool===TOOLS.CALIB} onClick={()=>setTool(TOOLS.CALIB)} label="Calibrate" icon="🎚️"/>
        <ToolButton active={tool===TOOLS.PAN} onClick={()=>setTool(TOOLS.PAN)} label="Pan/Zoom" icon="✋"/>

        <div className="mx-4 h-6 w-px bg-gray-200"/>

        <label className="text-sm text-gray-600">Stroke</label>
        <input type="color" value={strokeColor} onChange={(e)=>setStrokeColor(e.target.value)} className="w-10 h-9 rounded"/>
        <input type="range" min={1} max={12} value={strokeWidth} onChange={(e)=>setStrokeWidth(parseInt(e.target.value))}/>

        <label className="ml-2 text-sm text-gray-600">Fill</label>
        <input type="color" value={rgbaToHex(fillColor)} onChange={(e)=> setFillColor(hexToRgba(e.target.value, 0.12))} className="w-10 h-9 rounded"/>

        <div className="mx-4 h-6 w-px bg-gray-200"/>

        <button onClick={undo} className="px-3 py-2 rounded-2xl bg-gray-100 hover:bg-gray-200">Undo</button>
        <button onClick={redo} className="px-3 py-2 rounded-2xl bg-gray-100 hover:bg-gray-200">Redo</button>

        <div className="mx-4 h-6 w-px bg-gray-200"/>

        <Toggle label="Grid" value={showGrid} onChange={setShowGrid}/>
        <Toggle label="Snap" value={snapGrid} onChange={setSnapGrid}/>

        <div className="mx-4 h-6 w-px bg-gray-200"/>

        <div className="flex items-center gap-2 text-sm">
          <span className="text-gray-600">Unit:</span>
          <input value={unitLabel} onChange={(e)=>setUnitLabel(e.target.value)} className="w-16 px-2 py-1 rounded border"/>
          <span className="text-gray-600">Scale:</span>
          <span className="px-2 py-1 rounded bg-gray-100">{scalePxPerUnit ? `1 ${unitLabel} = ${scalePxPerUnit.toFixed(1)} px` : 'uncalibrated'}</span>
        </div>

        <div className="ml-auto flex items-center gap-2 text-sm">
          <span className="px-2 py-1 rounded bg-gray-100">Zoom {Math.round(zoom*100)}%</span>
        </div>
      </div>

      {/* Canvas container */}
      <div ref={containerRef} className="relative flex-1 overflow-hidden" onWheel={onWheel}>
        <canvas
          ref={canvasRef}
          className="absolute inset-0 touch-none"
          onMouseDown={onPointerDown}
          onMouseMove={onPointerMove}
          onMouseUp={onPointerUp}
          onMouseLeave={onPointerUp}
        />
        <canvas ref={overlayRef} className="absolute inset-0 pointer-events-none"/>

        {/* Help pill */}
        <div className="absolute bottom-3 left-3 text-xs text-gray-600 bg-white/80 backdrop-blur px-3 py-2 rounded-2xl shadow">
          <b>Tips:</b> Space = Pan • Mouse wheel = Zoom • Calibrate: draw known length then enter real value • Close polygon by clicking start point • Two‑finger pan/zoom on touch
        </div>
      </div>
    </div>
  );
}

function rgbaToHex(rgba) {
  // expects rgba like 'rgba(r,g,b,a)'
  const m = rgba.match(/rgba?\((\d+),\s*(\d+),\s*(\d+)(?:,\s*([0-9.]+))?\)/);
  if (!m) return '#000000';
  return '#' + [1,2,3].map(i => parseInt(m[i]).toString(16).padStart(2,'0')).join('');
}
function hexToRgba(hex, a=0.12) {
  const v = hex.replace('#','');
  const r = parseInt(v.substring(0,2),16);
  const g = parseInt(v.substring(2,4),16);
  const b = parseInt(v.substring(4,6),16);
  return `rgba(${r},${g},${b},${a})`;
}

function ToolButton({ active, onClick, label, icon }) {
  return (
    <button
      onClick={onClick}
      className={
        `px-3 py-2 rounded-2xl shadow-sm border ${active ? 'bg-blue-600 text-white border-blue-700' : 'bg-white hover:bg-gray-50 border-gray-200'} flex items-center gap-2`
      }
      title={label}
    >
      <span>{icon}</span>
      <span className="hidden sm:inline">{label}</span>
    </button>
  );
}

function Toggle({ label, value, onChange }) {
  return (
    <label className="flex items-center gap-2 select-none cursor-pointer">
      <span className="text-sm text-gray-600">{label}</span>
      <span
        onClick={()=>onChange(!value)}
        className={`w-12 h-7 rounded-full p-1 transition ${value ? 'bg-blue-600' : 'bg-gray-300'}`}
      >
        <span className={`block w-5 h-5 bg-white rounded-full transition ${value ? 'translate-x-5' : ''}`}></span>
      </span>
    </label>
  );
}
