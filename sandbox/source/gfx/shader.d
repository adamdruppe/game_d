module sandbox.gfx.shader;

import core.math;

import bindbc.opengl;

import sandbox.math;
import sandbox.gfx.camera;

public interface IShader
{
    void init();
    int compareTo(IShader other);
    bool canRender(Renderable renderable);
    void begin(Camera camera, RenderContext context);
    void render(Renderable renderable);
    void end();
}

public class ShaderProgram
{
    public static immutable string POSITION_ATTRIBUTE = "a_position";
    public static immutable string NORMAL_ATTRIBUTE = "a_normal";
    public static immutable string COLOR_ATTRIBUTE = "a_color";
    public static immutable string TEXCOORD_ATTRIBUTE = "a_texCoord";
    public static immutable string TANGENT_ATTRIBUTE = "a_tangent";
    public static immutable string BINORMAL_ATTRIBUTE = "a_binormal";
    public static immutable string BONEWEIGHT_ATTRIBUTE = "a_boneWeight";
    public static string prependVertexCode = "";
    public static string prependFragmentCode = "";
    public static bool pedantic = true;

    private string _log = "";
    private bool _isCompiled;

    private string[int] _uniforms;
    private string[int] _uniformTypes;
    private string[int] _uniformSizes;
    private string[] _uniformNames;

    private string[int] _attributes;
    private string[int] _attributeTypes;
    private string[int] _attributeSizes;
    private string[] _attributeNames;

    private int _program;
    private int _vertexShaderHandle;
    private int _fragmentShaderHandle;
    private string _vertexShaderSource;
    private string _fragmentShaderSource;

    private bool _invalidated;
    private int _refCount = 0;

    public this(string vertexShader, string fragmentShader)
    {
        assert(vertexShader == null);
        assert(fragmentShader == null);

        if (prependVertexCode !is null && prependVertexCode.length > 0)
            vertexShader = prependVertexCode ~= vertexShader;
        if (prependFragmentCode !is null && prependFragmentCode.length > 0)
            fragmentShader = prependFragmentCode ~= fragmentShader;

        _vertexShaderSource = vertexShader;
        _fragmentShaderSource = fragmentShader;

        compileShaders(vertexShader, fragmentShader);

        if (isCompiled())
        {
            fetchAttributes();
            fetchUniforms();
        }
    }

    private void compileShaders(string vertexShader, string fragmentShader)
    {
        _vertexShaderHandle = loadShader(GL_VERTEX_SHADER, vertexShader);
        _fragmentShaderHandle = loadShader(GL_FRAGMENT_SHADER, fragmentShader);

        if (_vertexShaderHandle == -1 || _fragmentShaderHandle == -1)
        {
            _isCompiled = false;
            return;
        }

        _program = linkProgram(createProgram());
        if (_program == -1)
        {
            _isCompiled = false;
            return;
        }

        _isCompiled = true;
    }

    private int loadShader(int type, string source)
    {
        return -1;
    }

    private int createProgram()
    {
        auto program = glCreateProgram();
        return program != 0 ? program : -1;
    }

    private int linkProgram(int program)
    {
        return -1;
    }

    private void fetchAttributes()
    {
    }

    private void fetchUniforms()
    {
    }

    public bool isCompiled()
    {
        return _isCompiled;
    }

}

public class Renderable
{
}

public class RenderContext
{

}
