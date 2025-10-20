string run_lstiter() {
	string result = "LSTITER:      ";
	try {
		var ft_lstiter = (d_lstiter)loader.symbol("ft_lstiter");
		result += SupraTest.test(null, () => {
			int nb1 = 1;
			int nb2 = 2;
			int nb3 = 3;
			t_list *node1 = t_list.create((void*)&nb1);
			node1->append((void*)&nb2);
			node1->append((void*)&nb3);
			ft_lstiter(node1, (content) => {
				int* ptr = (int*)content;
				*ptr += 10;
				return null;
			});
			t_list.free_list(node1);
			if (nb1 != 11) {
				stderr.printf("The first content was not modified correctly\n");
				return false;
			}
			if (nb2 != 12) {
				stderr.printf("The second content was not modified correctly\n");
				return false;
			}
			if (nb3 != 13) {
				stderr.printf("The third content was not modified correctly\n");
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
