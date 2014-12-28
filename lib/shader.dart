library shader;

import 'dart:web_gl' as WebGL;

class Shader
{
  void init(WebGL.RenderingContext glContext, String vsSource, String fsSource)
  {
    // vertex shader compilation
    WebGL.Shader vs = glContext.createShader(WebGL.RenderingContext.VERTEX_SHADER);
    glContext.shaderSource(vs, vsSource);
    glContext.compileShader(vs);
     
    // fragment shader compilation
    WebGL.Shader fs = glContext.createShader(WebGL.RenderingContext.FRAGMENT_SHADER);
    glContext.shaderSource(fs, fsSource);
    glContext.compileShader(fs);
     
    // attach shaders to a WebGL program
    _shaderProgram = glContext.createProgram();
    glContext.attachShader(_shaderProgram, vs);
    glContext.attachShader(_shaderProgram, fs);
    glContext.linkProgram(_shaderProgram);
    glContext.useProgram(_shaderProgram);
     
    /**
     * Check if shaders were compiled properly. This is probably the most painful part
     * since there's no way to "debug" shader compilation
     */
    if (!glContext.getShaderParameter(vs, WebGL.RenderingContext.COMPILE_STATUS)) { 
      print(glContext.getShaderInfoLog(vs));
    }
     
    if (!glContext.getShaderParameter(fs, WebGL.RenderingContext.COMPILE_STATUS)) { 
      print(glContext.getShaderInfoLog(fs));
    }
     
    if (!glContext.getProgramParameter(_shaderProgram, WebGL.RenderingContext.LINK_STATUS)) { 
      print(glContext.getProgramInfoLog(_shaderProgram));
    }
    
    _aVertexPosition = glContext.getAttribLocation(_shaderProgram, "aVertexPosition");
    glContext.enableVertexAttribArray(_aVertexPosition);
  }
  
  MatrixUniforms getMatrixUniforms(WebGL.RenderingContext glContext)
  {
    return new MatrixUniforms(
      glContext.getUniformLocation(_shaderProgram, "uPMatrix"),
      glContext.getUniformLocation(_shaderProgram, "uMVMatrix"),
      glContext.getUniformLocation(_shaderProgram, "uViewMatrix"));
  }
  
  int get AVertexPosition => _aVertexPosition;
  
  WebGL.Program _shaderProgram;
  int _aVertexPosition;
}

class MatrixUniforms
{
  MatrixUniforms(this.perspectiveMatrix, this.modelViewMatrix, this.viewMatrix);
  
  WebGL.UniformLocation perspectiveMatrix;
  WebGL.UniformLocation modelViewMatrix;
  WebGL.UniformLocation viewMatrix;
}