string run_lstnew() {
	string result = "LSTNEW:       ";
	try {
		var ft_lstnew = (d_lstnew)loader.symbol("ft_lstnew");
		result += SupraTest.test(null, () => {
			const string str = "Hello World";
			t_list *node = ft_lstnew((void*)str);
			if (node->content != (void*)str) {
				stderr.printf("lst->content != content");
				free(node);
				return false;
			}
			if (node->next != null) {
				stderr.printf("lst->next != NULL");
				free(node);
				return false;
			}
			if (node->next != null) {
				stderr.printf("lst->next != NULL");
				free(node);
				return false;
			}
			free(node);
			return true;
		}).msg_err();
		result += SupraTest.test(null, () => {
			t_list *node = ft_lstnew(null);
			if (node == null) {
				stderr.printf("ft_lstnew(null) it's valid");
				return false;
			}
			free(node);
			return true;
		}).msg_err();
		result += SupraTest.test(null, () => {
			const string str = "Etienne";
			SupraLeak.send_null();
			t_list *node = ft_lstnew(str);
			if (node == null)
				return true;
			return false;
		}).msg_err("Your malloc doesn't handle NULL properly");
		return result;
	}
	catch (Error e) {
		return @"$result \033[31m$(e.message)\033[0m";
	}
}
