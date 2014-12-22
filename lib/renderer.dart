library renderer;

import 'dart:html';
import 'dart:web_gl' as WebGL;
import 'package:vector_math/vector_math.dart';
import 'dart:typed_data';
import 'camera.dart';
import 'model.dart';

class Renderer
{
  Renderer(this.glContext, this.window);
  
  WebGL.RenderingContext glContext;
  WebGL.Program _shaderProgram;
  
  int width;
  int height;
  Window window;
  
  Matrix4 _pMatrix;
  Matrix4 _mvMatrix;
  
  WebGL.UniformLocation _uPMatrix;
  WebGL.UniformLocation _uMVMatrix;
  WebGL.UniformLocation _uViewMatrix;
  
  int _aVertexPosition;
  int _dimensions = 3;
  
  Vector3 position = new Vector3(0.0, 0.0, 0.0);
  
  Camera _camera;
  Model _model;
  
  void update(double time)
  {
    width = window.innerWidth;
    height = window.innerHeight;
    
    glContext.viewport(0, 0, width, height);
    glContext.clear(WebGL.RenderingContext.COLOR_BUFFER_BIT | WebGL.RenderingContext.DEPTH_BUFFER_BIT);
    
    _pMatrix = makePerspectiveMatrix(radians(45.0), width / height, 0.1, 100.0);
    // _pMatrix = makeOrthographicMatrix(-10.0, 10.0, -6.0, 6.0, -10.0, 10.0);
    
    _mvMatrix = new Matrix4.identity();
    _mvMatrix.translate(position);
    
    glContext.bindBuffer(WebGL.RenderingContext.ARRAY_BUFFER, _model.VertexPositionBuffer);
    glContext.vertexAttribPointer(_aVertexPosition, _dimensions, WebGL.RenderingContext.FLOAT, false, 0, 0);
    
    glContext.bindBuffer(WebGL.RenderingContext.ELEMENT_ARRAY_BUFFER, _model.VertexIndexBuffer);
    _setMatrixUniforms();
    glContext.drawElements(WebGL.RenderingContext.TRIANGLES, 36, WebGL.RenderingContext.UNSIGNED_SHORT, 0); // triangles, start at 0, total 3
    
    window.requestAnimationFrame(update);
  }
  
  void MoveRight()
  {
    position += new Vector3(0.0, 0.0, -0.1);
  }
  
  void MoveLeft()
  {
    position += new Vector3(0.0, 0.0, 0.1);
  }
  
  void MoveUp()
  {
    position += new Vector3(-0.1, 0.0, 0.0);
  }
  
  void MoveDown()
  {
    position += new Vector3(0.1, 0.0, 0.0);
  }
  
  void _initShaders() 
  {
    // vertex shader source code. uPosition is our variable that we'll
    // use to create animation
    String vsSource = """
    attribute vec3 aVertexPosition;

    uniform mat4 uMVMatrix;
    uniform mat4 uViewMatrix;
    uniform mat4 uPMatrix;

    void main(void) {
        gl_Position = uPMatrix * uViewMatrix * uMVMatrix * vec4(aVertexPosition, 1.0);
    }
    """;
    
    // fragment shader source code. uColor is our variable that we'll
    // use to animate color
    String fsSource = """
    precision mediump float;

    void main(void) {
        gl_FragColor = vec4(1.0, 1.0, 1.0, 1.0);
    }
    """;
    
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
    
    _uPMatrix = glContext.getUniformLocation(_shaderProgram, "uPMatrix");
    _uMVMatrix = glContext.getUniformLocation(_shaderProgram, "uMVMatrix");
    _uViewMatrix = glContext.getUniformLocation(_shaderProgram, "uViewMatrix");

  }
  
  void _setMatrixUniforms() 
  {
    Float32List tmpList = new Float32List(16);
    
    _pMatrix.copyIntoArray(tmpList);
    glContext.uniformMatrix4fv(_uPMatrix, false, tmpList);
    
    _mvMatrix.copyIntoArray(tmpList);
    glContext.uniformMatrix4fv(_uMVMatrix, false, tmpList);
    
    _camera.lookAt().copyIntoArray(tmpList);
    glContext.uniformMatrix4fv(_uViewMatrix, false, tmpList);
  }
  
  void start()
  {
    glContext.clearColor(0.0, 0.0, 0.0, 1.0);
    glContext.clearDepth(1.0);
    
    _camera = new Camera();
    _camera.Position = new Vector3(5.0, 5.0, 5.0);
    _camera.Target = new Vector3(0.0, 0.0, 0.0);
    
    _initShaders();
    
    _model = new Model();
    _model.init(glContext);
    
    update(0.0);
  }
}