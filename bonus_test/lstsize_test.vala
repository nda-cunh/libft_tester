string run_lstsize() {
	string result = "LSTSIZE:      ";
	try {
		var ft_lstsize = (d_lstsize)loader.symbol("ft_lstsize");
		result += SupraTest.test(null, () => {
			t_list *node1 = t_list.create((void*)"Node 1");
			node1->append((void*)4);
			node1->append((void*)5);
			node1->append((void*)8);
			int size = ft_lstsize((void*)node1);
			stderr.printf("size: %d != 4\n", size);
			t_list.free_list(node1);
			if (size != 4)
				return false;
			return true;
		}).msg_err();

		result += SupraTest.test(null, () => {
			t_list *node1 = t_list.create((void*)"Node 1");
			node1->append((void*)4);
			node1->append((void*)3);
			int size = ft_lstsize((void*)node1);
			stderr.printf("size: %d != 3\n", size);
			t_list.free_list(node1);
			if (size != 3)
				return false;
			return true;
		}).msg_err();

		result += SupraTest.test(null, () => {
			t_list *node1 = t_list.create((void*)"Node 1");
			node1->append((void*)4);
			int size = ft_lstsize((void*)node1);
			stderr.printf("size: %d != 2\n", size);
			t_list.free_list(node1);
			if (size != 2)
				return false;
			return true;
		}).msg_err();

		result += SupraTest.test(null, () => {
			t_list *node1 = t_list.create((void*)"Node 1");
			int size = ft_lstsize((void*)node1);
			stderr.printf("size: %d != 1\n", size);
			t_list.free_list(node1);
			if (size != 1)
				return false;
			return true;
		}).msg_err();
	}
	catch (Error e) {
		return @"$result \033[31m$(e.message)\033[0m";
	}
	return result;
}
