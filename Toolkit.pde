public class Vector {
	int x, y;
	Vector(int x, int y) { this.x = x; this.y = y; }
	Vector(Vector v) { this.x = v.x; this.y = v.y; }
}

public class Colour {
	int r, g, b, a;
	Colour(int r) { this.r = r; this.g = r; this.b = r; this.a = 255; }
	Colour(int r, int a) { this.r = r; this.g = r; this.b = r; this.a = a; }
	Colour(int r, int g, int b) { this.r = r; this.g = g; this.b = b; this.a = 255; }
	Colour(int r, int g, int b, int a) { this.r = r; this.g = g; this.b = b; this.a = a; }
}