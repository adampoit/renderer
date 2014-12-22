library camera;

import 'package:vector_math/vector_math.dart';

class Camera
{ 
  Vector3 _position = new Vector3(0.0, 0.0, 0.0);
  // Vector3 _rotation = new Vector3(0.0, 0.0, 0.0);
  Vector3 _lookAt = new Vector3(0.0, 0.0, 1.0);
  Vector3 _up = new Vector3(0.0, 1.0, 0.0);
  
  // Vector3 _lookAtRotation = new Vector3(0.0, 0.0, 1.0);
  // Vector3 _upRotation = new Vector3(0.0, 1.0, 0.0);
  
  Vector3 get Position                => _position;
          set Position(Vector3 value) => _position = value;
          
  Vector3 get Target                => _lookAt;
          set Target(Vector3 value) => _lookAt = value;
          
  Matrix4 lookAt()
  {
    Vector3 vz = (_position - _lookAt).normalized();
    Vector3 vx = (_up.cross(vz)).normalized();
    Vector3 vy = vz.cross(vx);
    
    var inverseViewMatrix = new Matrix4(vx.x, vx.y, vx.z, 0.0,
                                        vy.x, vy.y, vy.z, 0.0,
                                        vz.x, vz.y, vz.z, 0.0,
                                        _position.x, _position.y, _position.z, 1.0);
    
    inverseViewMatrix.invert();
    return inverseViewMatrix;
  }
  
  /* Vector3 get Rotation                => _rotation;
          set Rotation(Vector3 value) => _rotation = value;
  
  void MoveForward(double distance)
  {
    _position += _lookAt * distance;
  }
  
  void MoveLeft(double distance)
  {
    Vector3 left;
    
    cross3(_lookAtRotation, _upRotation, left);
    
    _position += left * distance;
  }
  
  void MoveRight(double distance)
  {
    Vector3 right;
    
    cross3(_upRotation, _lookAtRotation, right);
    
    _position += right * distance;
  }
  
  void MoveUp(double distance)
  {
    _position += _upRotation * distance;
  }
  
  void MoveDown(double distance)
  {
    _position -= _upRotation * distance;
  } */
}