library renderer;

import 'dart:html';
import 'dart:web_gl' as WebGL;
import 'package:vector_math/vector_math.dart';
import 'dart:typed_data';
import 'camera.dart';
import 'model.dart';
import 'shader.dart';

class Renderer
{
  Renderer(this.glContext, this.window);
  
  WebGL.RenderingContext glContext;
  
  void update(double time)
  {
    width = window.innerWidth;
    height = window.innerHeight;
    
    glContext.viewport(0, 0, width, height);
    glContext.clear(WebGL.RenderingContext.COLOR_BUFFER_BIT | WebGL.RenderingContext.DEPTH_BUFFER_BIT);
    
    _pMatrix = makeOrthographicMatrix(-10.0, 10.0, -6.5, 6.5, -10.0, 10.0);
    
    _mvMatrix = new Matrix4.identity();
    _mvMatrix.translate(_model.Position);
    
    if (_model.IsLoaded)
    {
      glContext.bindBuffer(WebGL.RenderingContext.ARRAY_BUFFER, _model.VertexPositionBuffer);
      glContext.vertexAttribPointer(_shader.AVertexPosition, _dimensions, WebGL.RenderingContext.FLOAT, false, 0, 0);
     
      glContext.bindBuffer(WebGL.RenderingContext.ELEMENT_ARRAY_BUFFER, _model.VertexIndexBuffer);
      _setMatrixUniforms();
      glContext.drawElements(WebGL.RenderingContext.TRIANGLES, 36, WebGL.RenderingContext.UNSIGNED_SHORT, 0); // triangles, start at 0, total 3
    }
    
    window.requestAnimationFrame(update);
  }
  
  void start(Model model)
  {
    glContext.clearColor(0.0, 0.0, 0.0, 1.0);
    glContext.clearDepth(1.0);
    
    _camera = new Camera();
    _camera.Position = new Vector3(0.5, 0.5, 0.5);
    _camera.Target = new Vector3(0.0, 0.0, 0.0);
    
    _initShaders();
    
    _model = model;
    
    update(0.0);
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
    
    _shader = new Shader();
    _shader.init(glContext, vsSource, fsSource);
    
    var uniforms = _shader.getMatrixUniforms(glContext);
    _uPMatrix = uniforms.perspectiveMatrix;
    _uMVMatrix = uniforms.modelViewMatrix;
    _uViewMatrix = uniforms.viewMatrix;
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
  
  int width;
  int height;
  Window window;
  
  Matrix4 _pMatrix;
  Matrix4 _mvMatrix;
  
  WebGL.UniformLocation _uPMatrix;
  WebGL.UniformLocation _uMVMatrix;
  WebGL.UniformLocation _uViewMatrix;
  
  int _dimensions = 3;
  
  Camera _camera;
  Model _model;
  Shader _shader;
}