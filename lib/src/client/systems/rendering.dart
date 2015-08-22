part of client;

Matrix4 createViewProjectionMatrix(TagManager tm, World world) {
  var pm = new Mapper<Position>(Position, world);

  var cameraEntity = tm.getEntity(cameraTag);
  var pos = pm[cameraEntity];
  var viewMatrix = new Matrix4.identity();
  var projMatrix = new Matrix4.identity();
  setViewMatrix(
      viewMatrix,
      new Vector3(pos.value.x, pos.value.x, pos.value.z),
      new Vector3(0.0, 0.0, 0.0),
      new Vector3(0.0, 1.0, 0.0));
  setPerspectiveMatrix(projMatrix, PI / 4, 800 / 600, 0.01, 1000);
  var viewProjectionMatrix = projMatrix * viewMatrix;

  return viewProjectionMatrix;
}

class RenderingSystem extends WebGlRenderingSystem {
  Mapper<Position> pm;
  Mapper<Dimensions> dm;
  Mapper<Renderable> rm;
  TagManager tm;

  Float32List items;
  Uint16List indices;
  static final int valuesPerItem = 4;
  static final int itemsPerEntity = 4 * 6;
  static final int idxPerEntity = 6;
  List<Attrib> attribs;

  RenderingSystem(RenderingContext gl)
      : super(gl, Aspect.getAspectForAllOf([Position, Dimensions, Renderable])) {
    attribs = [new Attrib('aPosition', 3), new Attrib('aColor', 3)];
  }

  @override
  void processEntity(int index, Entity entity) {
    var pos = pm[entity];
    var dim = dm[entity];
    var render = rm[entity];

    int offset = index * itemsPerEntity;
    int idxOffset = index * idxPerEntity;
    int itemOffset = index * valuesPerItem;

    items[offset] = pos.value.x;
    items[offset + 1] = pos.value.y;
    items[offset + 2] = pos.value.z;

    items[offset + 6] = pos.value.x + dim.value.x;
    items[offset + 7] = pos.value.y;
    items[offset + 8] = pos.value.z;

    items[offset + 12] = pos.value.x + dim.value.x;
    items[offset + 13] = pos.value.y + dim.value.y;
    items[offset + 14] = pos.value.z;

    items[offset + 18] = pos.value.x;
    items[offset + 19] = dim.value.y + pos.value.y;
    items[offset + 20] = pos.value.z;

    for (int i = 0; i < 4; i++) {
      items[offset + i * 6 + 3] = render.rgb.r;
      items[offset + i * 6 + 4] = render.rgb.g;
      items[offset + i * 6 + 5] = render.rgb.b;
    }

    indices[idxOffset] = itemOffset;
    indices[idxOffset + 1] = itemOffset + 1;
    indices[idxOffset + 2] = itemOffset + 2;

    indices[idxOffset + 3] = itemOffset;
    indices[idxOffset + 4] = itemOffset + 2;
    indices[idxOffset + 5] = itemOffset + 3;
  }

  @override
  void render(int length) {
    bufferElements(attribs, items, indices);

    var uViewProj = gl.getUniformLocation(program, 'uViewProj');
    gl.uniformMatrix4fv(uViewProj, false, createViewProjectionMatrix(tm, world).storage);

    gl.drawElements(TRIANGLES, length * idxPerEntity, UNSIGNED_SHORT, 0);
  }

  @override
  void updateLength(int length) {
    items = new Float32List(length * itemsPerEntity);
    indices = new Uint16List(length * idxPerEntity);
  }

  @override
  String get vShaderFile => 'RenderingSystem';
  @override
  String get fShaderFile => 'RenderingSystem';
}
