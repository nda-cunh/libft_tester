struct t_list
{
	void *content;
	t_list *next;
	public static t_list* create(void *content) {
		t_list* lst = malloc(sizeof(t_list));
		if (lst == null)
			return null;
		lst.content = content;
		lst.next = null;
		return lst;
	}
	public t_list* get_last_node() {
		t_list *current = &this;
		while (current.next != null) {
			current = current.next;
		}
		return current;
	}
	public t_list append(void *content) {
		t_list *new_node = t_list.create(content);
		t_list *last = this.get_last_node();
		last.next = new_node;
		return this;
	}
	public static void free_list(t_list *head, DelFunction? func = null) {
		t_list *current = head;
		t_list *next_node;
		while (current != null) {
			next_node = current->next;
			if (func != null) {
				func(current->content);
			}
			free(current);
			current = next_node;
		}
	}
	public int get_size() {
		int size = 0;
		t_list *current = &this;
		while (current != null) {
			size++;
			current = current.next;
		}
		return size;
	}
}

[CCode(has_target = false)]
delegate void*	Function (void *content);
[CCode(has_target = false)]
delegate void	DelFunction (void *content);

[CCode(has_target = false)]
delegate t_list *d_lstnew(void *content);
[CCode(has_target = false)]
delegate int d_lstsize(void *content);
[CCode(has_target = false)]
delegate void d_lstadd_front(t_list **lst, t_list *new);
[CCode(has_target = false)]
delegate void d_lstadd_back(t_list **lst, t_list *new);
[CCode(has_target = false)]
delegate t_list *d_lstlast(t_list *lst);
[CCode(has_target = false)]
delegate void d_lstdelone(t_list *lst, DelFunction func);
[CCode(has_target = false)]
delegate void d_lstclear(t_list **lst, DelFunction func);
[CCode(has_target = false)]
delegate void d_lstiter(t_list *lst, Function func);
[CCode(has_target = false)]
delegate t_list *d_lstmap(t_list *lst, Function func, DelFunction del);


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


string run_lstadd_front() {
	string result = "LSTADD_FRONT: ";
	try {
		var ft_lstadd_front = (d_lstadd_front)loader.symbol("ft_lstadd_front");
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

string run_lstmap() {
	string result = "LSTMAP:       ";
	try {
		var ft_lstmap = (d_lstmap)loader.symbol("ft_lstmap");

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
		
		result += SupraTest.test(null, () => {
			// Create the initial list
			t_list *node = t_list.create(strdup("1"));
			node->append(strdup("2"));
			node->append(strdup("3"));
			SupraLeak.send_null(); // Force malloc to fail

			// Map the list
			t_list *new_list = ft_lstmap(node,
				// Map Function
				(content) => {
					unowned string str = (string)content;
					void* new_content = (void*)int.parse(str);
					return (void*)new_content;
				}, // Delete Function

				(content) => {
				}
			);


			t_list.free_list(node, (content) => {
				free(content);
			});

			if (new_list != null) {
				stderr.printf("Your LSTMAP should return NULL on malloc failure and Free\n");
				t_list.free_list(new_list);
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
