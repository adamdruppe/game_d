module sandbox.gfx.camera;

import core.math;
import sandbox.math;

public abstract class Camera
{
    public Vec3 position = Vec3();
    public Vec3 direction = Vec3(0, 0, -1);
    public Vec3 up = Vec3(0, 1, 0);

    public Mat4 projection = Mat4();
    public Mat4 view = Mat4();
    public Mat4 combined = Mat4();
    public Mat4 invProjectionView = Mat4();

    public float near = 1;
    public float far = 100;

    public float viewportWidth = 0;
    public float viewportHeight = 0;

    public abstract void update(bool updateFrustum = true);

    public void lookAt(float x, float y, float z)
    {
        auto tmpVec = (Vec3(x, y, z) - position).nor();

        if (!tmpVec.isZero())
        {
            float dot = tmpVec.dot(up); // up and direction must ALWAYS be orthonormal vectors
            if (fabs(dot - 1) < 0.000000001f)
            {
                // Collinear
                up = direction * -1;
            }
            else if (fabs(dot + 1) < 0.000000001f)
            {
                // Collinear opposite
                up = direction;
            }
            direction = tmpVec;
            normalizeUp();
        }
    }

    public void normalizeUp()
    {
        auto tmpVec = direction.crs(up).nor();
        up = tmpVec.crs(direction).nor();
    }
}

public class OrthographicCamera : Camera
{
    public float zoom = 1;

    public this()
    {
        this.near = 0;
    }

    public this(float viewportWidth, float viewportHeight)
    {
        this.viewportWidth = viewportWidth;
        this.viewportHeight = viewportHeight;
        this.near = 0;
        update();
    }

    public override void update(bool updateFrustrum = true)
    {
        projection = Mat4.setToOrtho(zoom * -viewportWidth / 2, zoom * (viewportWidth / 2), zoom * -(viewportHeight / 2), zoom
			* viewportHeight / 2, near, far);
    }
}
