import java.util.concurrent.atomic.AtomicIntegerArray;

public class GetNSetState implements State{
	private AtomicIntegerArray m_arr;
	private int maxval;
	public GetNSetState(AtomicIntegerArray arr) {
		m_arr = arr;
		maxval = 127;
	}

	public GetNSetState(AtomicIntegerArray arr, int max_val) {
		m_arr = arr;
		maxval = max_val;
	}

	public int size() {
		return m_arr.length();
	}

	public byte[] current() {
		byte[] x = new byte[10];
		return x;
	}

	public boolean swap(int i, int j) {
		int first = m_arr.get(i);
		int second = m_arr.get(j);
		if(first <= 0 || second >= maxval) {
			return false;
		}
		m_arr.set(i, (first-1));
		m_arr.set(j, (first+1));
		return true;
	}
}