string run_lstlast() {
	string result = "LSTLAST:      ";
	try {
		var ft_lstlast = (d_lstlast)loader.symbol("ft_lstlast");
		result += SupraTest.test(null, () => {
			t_list *node1 = t_list.create((void*)"Node 1");
			node1->append((void*)"Node 2");
			node1->append((void*)"Node 3");
			t_list *last = ft_lstlast(node1);
			if (last->content != (void*)"Node 3") {
				stderr.printf("The last node content is not correct\n");
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
