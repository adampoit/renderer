library model;

import 'dart:web_gl' as WebGL;
import 'dart:typed_data';
import 'package:vector_math/vector_math.dart';
import 'dart:convert';
import 'dart:html';

class Model
{ 
  void init(WebGL.RenderingContext glContext, String url)
  {
    _cubeVertexPositionBuffer = glContext.createBuffer();
    glContext.bindBuffer(WebGL.RenderingContext.ARRAY_BUFFER, _cubeVertexPositionBuffer);
    
    _cubeVertexIndexBuffer = glContext.createBuffer();
    glContext.bindBuffer(WebGL.RenderingContext.ELEMENT_ARRAY_BUFFER, _cubeVertexIndexBuffer);
    
    var request = HttpRequest
        .getString(url)
        .then((content) => _onDataLoaded(content, glContext));
  }
  
  WebGL.Buffer get VertexPositionBuffer => _cubeVertexPositionBuffer;
      
  WebGL.Buffer get VertexIndexBuffer => _cubeVertexIndexBuffer;
    
  bool get IsLoaded => _loaded;
  
  Vector3 get Position                => _position;
          set Position(Vector3 value) => _position = value;
  
  void _onDataLoaded(String response, WebGL.RenderingContext glContext)
  {
    Map data = JSON.decode(response);
    
    glContext.bufferDataTyped(WebGL.RenderingContext.ARRAY_BUFFER, new Float32List.fromList(data["vertices"]), WebGL.RenderingContext.STATIC_DRAW);
    glContext.bufferDataTyped(WebGL.RenderingContext.ELEMENT_ARRAY_BUFFER, new Uint16List.fromList(data["indicies"]), WebGL.RenderingContext.STATIC_DRAW);
    
    _loaded = true;
  }
  
  Vector3 _position = new Vector3(0.0, 0.0, 0.0);
  bool _loaded = false;
  WebGL.Buffer _cubeVertexIndexBuffer;
  WebGL.Buffer _cubeVertexPositionBuffer;
}
