string run_lstadd_front() {
	string result = "LSTADD_FRONT: ";
	try {
		var ft_lstadd_front = (d_lstadd_front)loader.symbol("ft_lstadd_front");
		var shield = new SupraTest.Shield();
		shield.check(() => {
			t_list *node = t_list.create((void*)"Node");
			ft_lstadd_front(null, node);
			t_list.free_list(node);
			return true;
		}, "lstadd_front(NULL, node)");
		shield.check(() => {
			t_list *lst = t_list.create((void*)"Node");
			ft_lstadd_front(&lst, null);
			t_list.free_list(lst);
			return true;
		}, "lstadd_front(&lst, NULL)");
		result += shield.msg();

		result += SupraTest.test(null, () => {
			t_list *node1 = t_list.create((void*)"Node 1");
			t_list *node2 = t_list.create((void*)"Node 2");
			ft_lstadd_front(&node1, node2);
			if (node1 != node2) {
				stderr.printf("The new head is not correct\n");
				t_list.free_list(node1);
				return false;
			}
			if (node1->next->content != (void*)"Node 1") {
				stderr.printf("The second node is not correct\n");
				t_list.free_list(node1);
				return false;
			}
			if (node1->next->next != null) {
				stderr.printf("The list should end after two nodes\n");
				t_list.free_list(node1);
				return false;
			}
			if (node1->content != (void*)"Node 2") {
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
