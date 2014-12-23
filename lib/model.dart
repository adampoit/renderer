library model;

import 'dart:web_gl' as WebGL;
import 'dart:typed_data';
import 'package:vector_math/vector_math.dart';

class Model
{ 
  WebGL.Buffer get VertexPositionBuffer => _cubeVertexPositionBuffer;
  
  WebGL.Buffer get VertexIndexBuffer => _cubeVertexIndexBuffer;
  
  void init(WebGL.RenderingContext glContext)
  {
    _cubeVertexPositionBuffer = glContext.createBuffer();
    glContext.bindBuffer(WebGL.RenderingContext.ARRAY_BUFFER, _cubeVertexPositionBuffer);
         
    // fill "current buffer" with triangle verticies
    List<double> vertices = [
         // Front face
         -1.0, -1.0,  1.0,
          1.0, -1.0,  1.0,
          1.0,  1.0,  1.0,
         -1.0,  1.0,  1.0,
         
         // Back face
         -1.0, -1.0, -1.0,
         -1.0,  1.0, -1.0,
          1.0,  1.0, -1.0,
          1.0, -1.0, -1.0,
         
         // Top face
         -1.0,  1.0, -1.0,
         -1.0,  1.0,  1.0,
          1.0,  1.0,  1.0,
          1.0,  1.0, -1.0,
         
         // Bottom face
         -1.0, -1.0, -1.0,
          1.0, -1.0, -1.0,
          1.0, -1.0,  1.0,
         -1.0, -1.0,  1.0,
         
         // Right face
          1.0, -1.0, -1.0,
          1.0,  1.0, -1.0,
          1.0,  1.0,  1.0,
          1.0, -1.0,  1.0,
         
         // Left face
         -1.0, -1.0, -1.0,
         -1.0, -1.0,  1.0,
         -1.0,  1.0,  1.0,
         -1.0,  1.0, -1.0,
     ];
     glContext.bufferDataTyped(WebGL.RenderingContext.ARRAY_BUFFER, new Float32List.fromList(vertices), WebGL.RenderingContext.STATIC_DRAW);
     
     _cubeVertexIndexBuffer = glContext.createBuffer();
     glContext.bindBuffer(WebGL.RenderingContext.ELEMENT_ARRAY_BUFFER, _cubeVertexIndexBuffer);
     List<int> _cubeVertexIndices = [
          0,  1,  2,    0,  2,  3, // Front face
          4,  5,  6,    4,  6,  7, // Back face
          8,  9, 10,    8, 10, 11, // Top face
         12, 13, 14,   12, 14, 15, // Bottom face
         16, 17, 18,   16, 18, 19, // Right face
         20, 21, 22,   20, 22, 23  // Left face
         ];
     glContext.bufferDataTyped(WebGL.RenderingContext.ELEMENT_ARRAY_BUFFER, new Uint16List.fromList(_cubeVertexIndices), WebGL.RenderingContext.STATIC_DRAW);
  }
  
  Vector3 get Position                => _position;
          set Position(Vector3 value) => _position = value;
  
  Vector3 _position = new Vector3(0.0, 0.0, 0.0);  
  
  WebGL.Buffer _cubeVertexIndexBuffer;
  WebGL.Buffer _cubeVertexPositionBuffer;
}