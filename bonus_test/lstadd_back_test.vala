string run_lstadd_back() {
	string result = "LSTADD_BACK:  ";
	try {
		var ft_lstadd_back = (d_lstadd_back)loader.symbol("ft_lstadd_back");
		result += SupraTest.test(null, () => {
			t_list *node1 = t_list.create((void*)"Node 1");
			t_list *node2 = t_list.create((void*)"Node 2");
			ft_lstadd_back(&node1, node2);
			if (node1->next != node2) {
				stderr.printf("The second node is not correct\n");
				t_list.free_list(node1);
				return false;
			}
			if (node2->next != null) {
				stderr.printf("The list should end after two nodes\n");
				t_list.free_list(node1);
				return false;
			}
			if (node1->content != (void*)"Node 1") {
				stderr.printf("The head content is not correct\n");
				t_list.free_list(node1);
				return false;
			}
			t_list.free_list(node1);
			return true;
		}).msg_err();
	}
	catch (Error e) {
		return @"$result \033[31m$(e.message)\033[0m";
	}
	return result;
}
