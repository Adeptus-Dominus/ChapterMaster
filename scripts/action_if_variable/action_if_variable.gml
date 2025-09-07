/// @description (Old DnD) - if variable evauation
/// @param val1  value to check against
/// @param val2  value2 to check against
/// @param type	type of check (1=='<', 2=='>', 3=='<=', 4=='>='anything else is ==)
function action_if_variable(check_variable, compare_variable, check_type) {
	var ret = false;
	switch( check_type )
	{
		case 1:	ret = (check_variable < compare_variable); break;	
		case 2:	ret = (check_variable > compare_variable); break;	
		case 3:	ret = (check_variable <= compare_variable); break;	
		case 4:	ret = (check_variable >= compare_variable); break;	
		default:ret = (check_variable == compare_variable); break;	
	}
	return ret;


}
