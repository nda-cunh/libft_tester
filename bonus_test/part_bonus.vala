public struct t_list
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
public delegate void*	Function (void *content);
[CCode(has_target = false)]
public delegate void	DelFunction (void *content);

[CCode(has_target = false)]
public delegate t_list *d_lstnew(void *content);
[CCode(has_target = false)]
public delegate int d_lstsize(void *content);
[CCode(has_target = false)]
public delegate void d_lstadd_front(t_list **lst, t_list *new);
[CCode(has_target = false)]
public delegate void d_lstadd_back(t_list **lst, t_list *new);
[CCode(has_target = false)]
public delegate t_list *d_lstlast(t_list *lst);
[CCode(has_target = false)]
public delegate void d_lstdelone(t_list *lst, DelFunction func);
[CCode(has_target = false)]
public delegate void d_lstclear(t_list **lst, DelFunction func);
[CCode(has_target = false)]
public delegate void d_lstiter(t_list *lst, Function func);
[CCode(has_target = false)]
public delegate t_list *d_lstmap(t_list *lst, Function func, DelFunction del);
