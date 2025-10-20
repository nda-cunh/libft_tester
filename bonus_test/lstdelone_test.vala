string run_lstdelone() {
	string result = "LSTDELONE:    ";
	try {
		var ft_lstdelone = (d_lstdelone)loader.symbol("ft_lstdelone");
		result += SupraTest.test(null, () => {
			int nb1 = 5;
			int nb2 = 5;
			t_list *node1 = t_list.create((void*)&nb1);
			t_list *node2 = t_list.create((void*)&nb2);
			ft_lstdelone(node1, (content) => {
				int* ptr = (int*)content;
				*ptr = 66;
			});
			ft_lstdelone(node2, (content) => {
				int* ptr = (int*)content;
				*ptr = 42;
			});
			if (nb1 != 66) {
				stderr.printf("The first content was not modified correctly\n");
				return false;
			}
			if (nb2 != 42) {
				stderr.printf("The second content was not modified correctly\n");
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
