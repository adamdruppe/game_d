module sandbox.math;

import std.math;
import std.range;
import std.format;
import std.conv;
import std.string;

public struct Vec2
{
    public float x;
    public float y;

    public this(float x, float y)
    {
        this.x = x;
        this.y = y;
    }
}

public struct Vec3
{
    public float x;
    public float y;
    public float z;

    public this(float x, float y, float z)
    {
        this.x = x;
        this.y = y;
        this.z = z;
    }

    public float len2()
    {
        return x * x + y * y + z * z;
    }

    public Vec3 nor()
    {
        float len2 = len2();
        if (len2 == 0f || len2 == 1f)
            return Vec3(x, y, z);

        float scalar = 1f / sqrt(len2);

        return Vec3(x * scalar, y * scalar, z * scalar);
    }

    
	public float dot(Vec3 vector) {
		return x * vector.x + y * vector.y + z * vector.z;
	}

    public Vec3 crs(Vec3 vector)
     {
		return Vec3(y * vector.z - z * vector.y, z * vector.x - x * vector.z, x * vector.y - y * vector.x);
	}

    public bool isZero()
    {
        return x == 0 && y == 0 && z == 0;
    }

    Vec3 opUnary(string s)() if (s == "-")
    {
        return Vec3(-x, -y, -z);
    }

    Vec3 opBinary(string op)(Vec3 other)
    {
        static if (op == "+")      return Vec3(x + other.x, y + other.y, z + other.z);
        else static if (op == "-") return Vec3(x - other.x, y - other.y, z - other.z);
        else static if (op == "*") return Vec3(x * other.x, y * other.y, z * other.z);
        else static if (op == "/") return Vec3(x / other.x, y / other.y, z / other.z);
        else static assert(0, "Operator "~op~" not implemented");
    }
    Vec3 opBinary(string op)(float other)
    {
        static if (op == "+")      return Vec3(x + other, y + other, z + other);
        else static if (op == "-") return Vec3(x - other, y - other, z - other);
        else static if (op == "*") return Vec3(x * other, y * other, z * other);
        else static if (op == "/") return Vec3(x / other, y / other, z / other);
        else static assert(0, "Operator "~op~" not implemented");
    }
}

public struct Vec4
{
    public float x;
    public float y;
    public float z;
    public float w;
}

public struct Mat4
{
    public static immutable int M00 = 0;
    public static immutable int M01 = 4;
    public static immutable int M02 = 8;
    public static immutable int M03 = 12;
    public static immutable int M10 = 1;
    public static immutable int M11 = 5;
    public static immutable int M12 = 9;
    public static immutable int M13 = 13;
    public static immutable int M20 = 2;
    public static immutable int M21 = 6;
    public static immutable int M22 = 10;
    public static immutable int M23 = 14;
    public static immutable int M30 = 3;
    public static immutable int M31 = 7;
    public static immutable int M32 = 11;
    public static immutable int M33 = 15;
    public float[16] val;

    public static Mat4 identity()
    {
        auto ret = Mat4();
        ret.val[M00] = 1f;
        ret.val[M11] = 1f;
        ret.val[M22] = 1f;
        ret.val[M33] = 1f;
        return ret;
    }

    public static Mat4 setToOrtho (float left, float right, float bottom, float top, float near, float far) 
    {
        auto ret = Mat4();

        float x_orth = 2 / (right - left);
		float y_orth = 2 / (top - bottom);
		float z_orth = -2 / (far - near);

		float tx = -(right + left) / (right - left);
		float ty = -(top + bottom) / (top - bottom);
		float tz = -(far + near) / (far - near);

        ret.val[M00] = x_orth;
		ret.val[M10] = 0;
		ret.val[M20] = 0;
		ret.val[M30] = 0;
		ret.val[M01] = 0;
		ret.val[M11] = y_orth;
		ret.val[M21] = 0;
		ret.val[M31] = 0;
		ret.val[M02] = 0;
		ret.val[M12] = 0;
		ret.val[M22] = z_orth;
		ret.val[M32] = 0;
		ret.val[M03] = tx;
		ret.val[M13] = ty;
		ret.val[M23] = tz;
		ret.val[M33] = 1;

        return ret;
    }

    public static Mat4 setToLookAt (Vec3 position, Vec3 target, Vec3 up)
    {

        auto tmp = target - position;
        auto ret = setToLookAt(tmp, up);
        
        return ret;
    }

    public static Mat4 setToLookAt (Vec3 direction, Vec3 up)
    {
        auto l_vez = direction.nor();
		auto l_vex = direction.nor();
		
        l_vex = l_vex.crs(up).nor();
		auto l_vey = l_vex.crs(l_vez).nor();

        auto ret = Mat4();
		ret.val[M00] = l_vex.x;
		ret.val[M01] = l_vex.y;
		ret.val[M02] = l_vex.z;
		ret.val[M10] = l_vey.x;
		ret.val[M11] = l_vey.y;
		ret.val[M12] = l_vey.z;
		ret.val[M20] = -l_vez.x;
		ret.val[M21] = -l_vez.y;
		ret.val[M22] = -l_vez.z;

		return ret;
    }
}
