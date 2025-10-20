string run_lstclear() {
	string result = "LSTCLEAR:     ";
	try {
		var ft_lstclear = (d_lstclear)loader.symbol("ft_lstclear");
		result += SupraTest.test(null, () => {
			int nb1 = 5;
			int nb2 = 3;
			int nb3 = 2;
			t_list *node1 = t_list.create((void*)&nb1);
			node1->append((void*)&nb2);
			node1->append((void*)&nb3);
			ft_lstclear(&node1, (content) => {
				int* ptr = (int*)content;
				*ptr = 99;
			});
			if (nb1 != 99) {
				stderr.printf("The first content was not modified correctly\n");
				return false;
			}
			if (nb2 != 99) {
				stderr.printf("The second content was not modified correctly\n");
				return false;
			}
			if (nb3 != 99) {
				stderr.printf("The third content was not modified correctly\n");
				return false;
			}
			if (node1 != null) {
				stderr.printf("The list head should be NULL after clear\n");
				return false;
			}
			return true;
		}).msg_err();
	}
	catch (Error e) {
		return @"$result \033[31m$(e.message)\033[0m";
	}
	return result;
}
