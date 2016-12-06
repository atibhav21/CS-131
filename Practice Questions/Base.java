class A {
	public A() {
		System.out.println("A()");
		doStuff();
	}
	public void doStuff() {
		System.out.println("A.doStuff()");
	}

}

class B extends A {
	int i = 7;
	public B() {
		System.out.println("B()");
	}

	public void doStuff() {
		System.out.println("B.doStuff() " + i);
	}
}

public class Base {
	public static void main(String[] args) 
	{
		B b = new B();
		b.doStuff();
	}
}