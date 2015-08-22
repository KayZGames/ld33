uniform mat4 uViewProj;

attribute vec4 aPosition;
attribute vec3 aColor;

varying vec3 vColor;

void main() {
	gl_Position = uViewProj * aPosition;
	vColor = aColor;
}
