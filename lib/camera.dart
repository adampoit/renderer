library camera;

import 'package:vector_math/vector_math.dart';

class Camera
{         
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
  
  Vector3 get Position                => _position;
          set Position(Vector3 value) => _position = value;
            
  Vector3 get Target                => _lookAt;
          set Target(Vector3 value) => _lookAt = value;
  
  Vector3 _position = new Vector3(0.0, 0.0, 0.0);
  Vector3 _lookAt = new Vector3(0.0, 0.0, 1.0);
  Vector3 _up = new Vector3(0.0, 1.0, 0.0);
}
