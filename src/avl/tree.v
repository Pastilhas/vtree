module avl

const max_height = 32

struct Tree[T] {
mut:
	cmp  fn (T, T) int @[required]
	root &Node[T] = unsafe { 0 }
	size usize
}

pub fn new[T](cmp fn (T, T) int) Tree[T] {
	return Tree[T]{
		cmp: cmp
	}
}

pub fn (t Tree[T]) to_array[T]() []T {
	if unsafe { t.root == 0 } {
		return []T{}
	}
	return t.in_order(t.root)
}

fn (t Tree[T]) is_valid[T]() bool {
	return unsafe { t.root == 0 } || t.node_is_valid(t.root)
}

fn (t Tree[T]) node_is_valid[T](n &Node[T]) bool {
	l := unsafe { n.left == 0 } || (t.cmp(n.left.data, n.data) < 0 && t.node_is_valid(n.left))
	r := unsafe { n.right == 0 } || (t.cmp(n.right.data, n.data) < 0 && t.node_is_valid(n.right))

	return l && r
}

fn (t Tree[T]) in_order[T](n &Node[T]) []T {
	mut res := []T{}

	if unsafe { n.left != 0 } {
		res << t.in_order(n.left)
	}

	res << *n.data

	if unsafe { n.right != 0 } {
		res << t.in_order(n.right)
	}

	return res
}

fn (mut t AVLTree[T]) switch_parent[T](p &AVLNode[T], n &AVLNode[T]) {
	mut q := p.parent
	if unsafe { q == 0 } {
		t.root = n

		if unsafe { n != 0 } {
			t.root.parent = q
		}

		return
	}

	if q.is_left(p) {
		q.set_left(n)
	} else {
		q.set_right(n)
	}
}
