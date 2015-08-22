part of client;

class RenderingSystem extends WebGlRenderingSystem {
  Mapper<Position> pm;

  Float32List items;
  Uint16List indices;
  int valuesPerItem = 4;
  int itemsPerEntity = 4 * 3;
  int idxPerEntity = 6;
  List<Attrib> attribs;

  RenderingSystem(RenderingContext gl)
      : super(gl, Aspect.getAspectForAllOf([Position, Renderable])) {
    attribs = [new Attrib('aPosition', 3)];
  }

  @override
  void processEntity(int index, Entity entity) {
    var pos = pm[entity];
    int offset = index * itemsPerEntity;
    int idxOffset = index * idxPerEntity;
    int itemOffset = index * valuesPerItem;

    items[offset] = -0.1 + pos.value.x;
    items[offset + 1] = -0.1 + pos.value.y;
    items[offset + 2] = pos.value.z;

    items[offset + 3] = 0.1 + pos.value.x;
    items[offset + 4] = -0.1 + pos.value.y;
    items[offset + 5] = pos.value.z;

    items[offset + 6] = 0.1 + pos.value.x;
    items[offset + 7] = 0.1 + pos.value.y;
    items[offset + 8] = pos.value.z;

    items[offset + 9] = -0.1 + pos.value.x;
    items[offset + 10] = 0.1 + pos.value.y;
    items[offset + 11] = pos.value.z;

    indices[idxOffset] = itemOffset;
    indices[idxOffset + 1] = itemOffset + 1;
    indices[idxOffset + 2] = itemOffset + 2;

    indices[idxOffset + 3] = itemOffset;
    indices[idxOffset + 4] = itemOffset + 2;
    indices[idxOffset + 5] = itemOffset + 3;
  }

  @override
  void render(int length) {
    print(items);
    print(indices);
    bufferElements(attribs, items, indices);

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
