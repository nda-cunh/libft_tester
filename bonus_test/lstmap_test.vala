string run_lstmap() {
	string result = "LSTMAP:       ";
	try {
		var ft_lstmap = (d_lstmap)loader.symbol("ft_lstmap");

		var shield = new SupraTest.Shield();
		shield.check(() => {
			t_list.free_list(ft_lstmap(null, (content) => { return content; }, (content) => {}));
			return true;
		}, "lstmap(NULL, f, del)");
		shield.check(() => {
			t_list *lst = t_list.create((void*)"Node");
			t_list.free_list(ft_lstmap(lst, null, (content) => {}));
			t_list.free_list(lst);
			return true;
		}, "lstmap(lst, NULL, del)");
		shield.check(() => {
			t_list *lst = t_list.create((void*)"Node");
			t_list.free_list(ft_lstmap(lst, (content) => { return content; }, null));
			t_list.free_list(lst);
			return true;
		}, "lstmap(lst, f, NULL)");
		result += shield.msg();

		// Test 1
		result += SupraTest.test(null, () => {
			// Create the initial list
			t_list *node = t_list.create(strdup("1"));
			node->append(strdup("2"));
			node->append(strdup("3"));

			// Map the list
			t_list *new_list = ft_lstmap(node,
				// Map Function
				(content) => {
					unowned string str = (string)content;
					void* new_content = (void*)int.parse(str);
					return (void*)new_content;
				},
				// Delete Function
				(content) => {
				}
			);

			if (new_list == null) {
				stderr.printf("Your LSTMAP return null instead of a valid list\n");
				t_list.free_list(node, (content) => {
					free(content);
				});
				return false;
			}
			// test if the original list is unchanged
			if (node->get_size() != 3) {
				stderr.printf("The original list size has been modified\n");
				t_list.free_list(new_list);
				return false;
			}

			// test if the content of the original list is unchanged
			if (strcmp((string)node->content, "1") != 0 ||
				strcmp((string)node->next->content, "2") != 0 ||
				strcmp((string)node->next->next->content, "3") != 0) {
				stderr.printf("The original list content has been modified\n");
				t_list.free_list(new_list);
				return false;
			}

			t_list.free_list(node, (content) => {
				free(content);
			});

			if (new_list->get_size() != 3) {
				stderr.printf("The new_list size is not correct need 3 but got %d\n", new_list->get_size());
				t_list.free_list(new_list);
				return false;
			}

			if (new_list->content != (void*)1) {
				stderr.printf("The first new_list content is not correct\n");
				t_list.free_list(new_list);
				return false;
			}

			if (new_list->next->content != (void*)2) {
				stderr.printf("The second new_list content is not correct\n");
				t_list.free_list(new_list);
				return false;
			}

			if (new_list->next->next->content != (void*)3) {
				stderr.printf("The third new_list content is not correct\n");
				t_list.free_list(new_list);
				return false;
			}

			t_list.free_list(new_list);

			return true;
		}).msg_err();
		
		// Fail each malloc of lstmap: the contents already made by f must be freed with del
		result += SupraTest.test_each_malloc((n) => {
			// Create the initial list
			t_list *node = t_list.create(strdup("1"));
			node->append(strdup("2"));
			node->append(strdup("3"));

			SupraLeak.fail_at(n);
			// Map the list
			t_list *new_list = ft_lstmap(node,
				// Map Function (its own malloc never fails)
				(content) => {
					SupraLeak.pause();
					void *new_content = strdup((string)content);
					SupraLeak.resume();
					return new_content;
				},
				// Delete Function
				(content) => {
					free(content);
				}
			);
			SupraLeak.fail_at(0);

			t_list.free_list(node, (content) => {
				free(content);
			});

			if (SupraLeak.has_failed && new_list != null) {
				stderr.printf("ft_lstmap must return NULL when its malloc n°%d fails, but returned a list", n);
				t_list.free_list(new_list, (content) => {
					free(content);
				});
				return false;
			}
			if (!SupraLeak.has_failed && new_list == null) {
				stderr.printf("ft_lstmap returned NULL but no malloc failed (expected a list of 3 nodes): your function returns NULL outside of a malloc failure");
				return false;
			}
			t_list.free_list(new_list, (content) => {
				free(content);
			});
			return true;
		}, "no protect ").msg_err();
	}
	catch (Error e) {
		return @"$result \033[31m$(e.message)\033[0m";
	}
	return result;
}
