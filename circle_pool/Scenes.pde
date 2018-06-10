void createWheel(Node[] nodes, Node[] frames, int size, int side_len, int up) {  
  //INSIDE
  nodes[0] = new Node(new PVector(size, size+up, size));
  nodes[1] = new Node(new PVector(size, -size+up, size));
  nodes[2] = new Node(new PVector(size, size+up, -size));
  nodes[3] = new Node(new PVector(size, -size+up, -size));
  nodes[4] = new Node(new PVector(-size, size+up, size));
  nodes[5] = new Node(new PVector(-size, -size+up, size));
  nodes[6] = new Node(new PVector(-size, size+up, -size));
  nodes[7] = new Node(new PVector(-size, -size+up, -size));
  
  //DOWN
  nodes[8] = new Node(new PVector(size, size+up+side_len, size));
  nodes[9] = new Node(new PVector(-size, size+up+side_len, size));
  nodes[10] = new Node(new PVector(size, size+up+side_len, -size));
  nodes[11] = new Node(new PVector(-size, size+up+side_len, -size));
  
  // UP 
  nodes[12] = new Node(new PVector(size, -size+up-side_len, size));
  nodes[13] = new Node(new PVector(-size, -size+up-side_len, size));
  nodes[14] = new Node(new PVector(size, -size+up-side_len, -size));
  nodes[15] = new Node(new PVector(-size, -size+up-side_len, -size));
  
  //LEFT
  nodes[16] = new Node(new PVector(-size-side_len, -size+up, -size));
  nodes[17] = new Node(new PVector(-size-side_len, -size+up, size));
  nodes[18] = new Node(new PVector(-size-side_len, size+up, -size));
  nodes[19] = new Node(new PVector(-size-side_len, size+up, size));
  
  //RIGHT
  nodes[20] = new Node(new PVector(size+side_len, -size+up, -size));
  nodes[21] = new Node(new PVector(size+side_len, -size+up, size));
  nodes[22] = new Node(new PVector(size+side_len, size+up, -size));
  nodes[23] = new Node(new PVector(size+side_len, size+up, size));
  
  //UR connections
  nodes[12].connections.add(nodes[21]);
  nodes[14].connections.add(nodes[20]);
  
  //UL connections
  nodes[13].connections.add(nodes[17]);
  nodes[15].connections.add(nodes[16]);
  
  //DR connections
  nodes[8].connections.add(nodes[23]);
  nodes[10].connections.add(nodes[22]);
  
  //DL connections 
  nodes[9].connections.add(nodes[19]);
  nodes[11].connections.add(nodes[18]);
  
  //outside connections down 
  nodes[8].connections.add(nodes[9]);
  nodes[9].connections.add(nodes[11]);
  nodes[10].connections.add(nodes[8]);
  nodes[11].connections.add(nodes[10]);

  //outside connections Up
  nodes[12].connections.add(nodes[13]);
  nodes[13].connections.add(nodes[15]);
  nodes[14].connections.add(nodes[12]);
  nodes[15].connections.add(nodes[14]);
  
  //outside connections left 
  nodes[16].connections.add(nodes[17]);
  nodes[17].connections.add(nodes[19]);
  nodes[18].connections.add(nodes[16]);
  nodes[19].connections.add(nodes[18]);
  
  //outside connections right
  nodes[20].connections.add(nodes[21]);
  nodes[21].connections.add(nodes[23]);
  nodes[22].connections.add(nodes[20]);
  nodes[23].connections.add(nodes[22]);
  
  
  //Connections in the inside cube
  nodes[0].connections.add(nodes[1]);
  nodes[0].connections.add(nodes[2]);
  nodes[0].connections.add(nodes[4]);
  nodes[1].connections.add(nodes[3]);
  nodes[1].connections.add(nodes[5]);
  nodes[2].connections.add(nodes[3]);
  nodes[2].connections.add(nodes[6]);
  nodes[3].connections.add(nodes[7]);
  nodes[4].connections.add(nodes[5]);
  nodes[4].connections.add(nodes[6]);
  nodes[5].connections.add(nodes[7]);
  nodes[6].connections.add(nodes[7]); 
  
  //FRAME
  frames[0] = new Node(new PVector(size, size+up, size));
  frames[1] = new Node(new PVector(size, -size+up, size));
  frames[2] = new Node(new PVector(size, size+up, -size));
  frames[3] = new Node(new PVector(size, -size+up, -size));
  frames[4] = new Node(new PVector(-size, size+up, size));
  frames[5] = new Node(new PVector(-size, -size+up, size));
  frames[6] = new Node(new PVector(-size, size+up, -size));
  frames[7] = new Node(new PVector(-size, -size+up, -size));
  
  //DOWN
  frames[8] = new Node(new PVector(size, size+up+side_len, size));
  frames[9] = new Node(new PVector(-size, size+up+side_len, size));
  frames[10] = new Node(new PVector(size, size+up+side_len, -size));
  frames[11] = new Node(new PVector(-size, size+up+side_len, -size));
  
  // UP 
  frames[12] = new Node(new PVector(size, -size+up-side_len, size));
  frames[13] = new Node(new PVector(-size, -size+up-side_len, size));
  frames[14] = new Node(new PVector(size, -size+up-side_len, -size));
  frames[15] = new Node(new PVector(-size, -size+up-side_len, -size));
  
  //LEFT
  frames[16] = new Node(new PVector(-size-side_len, -size+up, -size));
  frames[17] = new Node(new PVector(-size-side_len, -size+up, size));
  frames[18] = new Node(new PVector(-size-side_len, size+up, -size));
  frames[19] = new Node(new PVector(-size-side_len, size+up, size));
  
  //RIGHT
  frames[20] = new Node(new PVector(size+side_len, -size+up, -size));
  frames[21] = new Node(new PVector(size+side_len, -size+up, size));
  frames[22] = new Node(new PVector(size+side_len, size+up, -size));
  frames[23] = new Node(new PVector(size+side_len, size+up, size));

  //FRAME MOVEMENT inside
  frames[0].next_node = frames[1];
  frames[1].next_node = frames[3];
  frames[2].next_node = frames[0];
  frames[3].next_node = frames[2];
  frames[4].next_node = frames[5];
  frames[5].next_node = frames[7];
  frames[6].next_node = frames[4];
  frames[7].next_node = frames[6];
  
  //FRAME movement outside
  frames[12].next_node = frames[13];
  frames[14].next_node = frames[15];
  frames[13].next_node = frames[17];
  frames[15].next_node = frames[16];
  frames[16].next_node = frames[18];
  frames[17].next_node = frames[19];
  frames[18].next_node = frames[11];
  frames[19].next_node = frames[9];
  frames[11].next_node = frames[10];
  frames[9].next_node = frames[8];
  frames[8].next_node = frames[23];
  frames[10].next_node = frames[22];
  frames[22].next_node = frames[20];
  frames[23].next_node = frames[21];
  frames[20].next_node = frames[12];
  frames[21].next_node = frames[14];
  
  //init all nodes
  nodes[0].to_node = frames[0].next_node;
  nodes[0].from_node = frames[0];
  nodes[1].to_node = frames[1].next_node;
  nodes[1].from_node = frames[1];
  nodes[2].to_node = frames[2].next_node;
  nodes[2].from_node = frames[2];
  nodes[3].to_node = frames[3].next_node;
  nodes[3].from_node = frames[3];
  nodes[4].to_node = frames[4].next_node;
  nodes[4].from_node = frames[4];
  nodes[5].to_node = frames[5].next_node;
  nodes[5].from_node = frames[5];
  nodes[6].to_node = frames[6].next_node;
  nodes[6].from_node = frames[6];
  nodes[7].to_node = frames[7].next_node;
  nodes[7].from_node = frames[7];
  nodes[8].to_node = frames[8].next_node;
  nodes[8].from_node = frames[8];
  nodes[9].to_node = frames[9].next_node;
  nodes[9].from_node = frames[9];
  nodes[10].to_node = frames[10].next_node;
  nodes[10].from_node = frames[10];
  nodes[11].to_node = frames[11].next_node;
  nodes[11].from_node = frames[11];
  nodes[12].to_node = frames[12].next_node;
  nodes[12].from_node = frames[12];
  nodes[13].to_node = frames[13].next_node;
  nodes[13].from_node = frames[13];
  nodes[14].to_node = frames[14].next_node;
  nodes[14].from_node = frames[14];
  nodes[15].to_node = frames[15].next_node;
  nodes[15].from_node = frames[15];
  nodes[16].to_node = frames[16].next_node;
  nodes[16].from_node = frames[16];
  nodes[17].to_node = frames[17].next_node;
  nodes[17].from_node = frames[17];
  nodes[18].to_node = frames[18].next_node;
  nodes[18].from_node = frames[18];
  nodes[19].to_node = frames[19].next_node;
  nodes[19].from_node = frames[19];
  nodes[20].to_node = frames[20].next_node;
  nodes[20].from_node = frames[20];
  nodes[21].to_node = frames[20].next_node;
  nodes[21].from_node = frames[20];
  nodes[22].to_node = frames[20].next_node;
  nodes[22].from_node = frames[20];
  nodes[23].to_node = frames[20].next_node;
  nodes[23].from_node = frames[20]; 
}

void createCubeInCube(Node[] nodes, int side, int up) {
  nodes[0] = new Node(new PVector(side, side+up, side));
  nodes[1] = new Node(new PVector(side, -side+up, side));
  nodes[2] = new Node(new PVector(side, side+up, -side));
  nodes[3] = new Node(new PVector(side, -side+up, -side));
  nodes[4] = new Node(new PVector(-side, side+up, side));
  nodes[5] = new Node(new PVector(-side, -side+up, side));
  nodes[6] = new Node(new PVector(-side, side+up, -side));
  nodes[7] = new Node(new PVector(-side, -side+up, -side));
  
  nodes[8] = new Node(new PVector(side, side+up, side));
  nodes[9] = new Node(new PVector(side, -side+up, side));
  nodes[10] = new Node(new PVector(side, side+up, -side));
  nodes[11] = new Node(new PVector(side, -side+up, -side));
  nodes[12] = new Node(new PVector(-side, side+up, side));
  nodes[13] = new Node(new PVector(-side, -side+up, side));
  nodes[14] = new Node(new PVector(-side, side+up, -side));
  nodes[15] = new Node(new PVector(-side, -side+up, -side));
  
  nodes[0].next_node = nodes[1];
  nodes[1].next_node = nodes[3];
  nodes[2].next_node = nodes[0];
  nodes[3].next_node = nodes[2];
  
  nodes[4].next_node = nodes[5];
  nodes[5].next_node = nodes[7];
  nodes[6].next_node = nodes[0];
  nodes[7].next_node = nodes[6];
  
  nodes[4].to_node = nodes[0].next_node;
  nodes[5].to_node = nodes[1].next_node;
  nodes[6].to_node = nodes[2].next_node;
  nodes[7].to_node = nodes[3].next_node;
  nodes[4].from_node = nodes[0];
  nodes[5].from_node = nodes[1];
  nodes[6].from_node = nodes[2];
  nodes[7].from_node = nodes[3];
}

void createCube(Node[] nodes, Node[] frames, int side_len, int up) {
    nodes[0] = new Node(new PVector(side, side+up, side));
  nodes[1] = new Node(new PVector(side, -side+up, side));
  nodes[2] = new Node(new PVector(side, side+up, -side));
  nodes[3] = new Node(new PVector(side, -side+up, -side));
  nodes[4] = new Node(new PVector(-side, side+up, side));
  nodes[5] = new Node(new PVector(-side, -side+up, side));
  nodes[6] = new Node(new PVector(-side, side+up, -side));
  nodes[7] = new Node(new PVector(-side, -side+up, -side));
  
  nodes[8] = new Node(new PVector(side, side+up, side));
  nodes[9] = new Node(new PVector(side, -side+up, side));
  nodes[10] = new Node(new PVector(side, side+up, -side));
  nodes[11] = new Node(new PVector(side, -side+up, -side));
  nodes[12] = new Node(new PVector(-side, side+up, side));
  nodes[13] = new Node(new PVector(-side, -side+up, side));
  nodes[14] = new Node(new PVector(-side, side+up, -side));
  nodes[15] = new Node(new PVector(-side, -side+up, -side));
  
  nodes[0].next_node = nodes[1];
  nodes[1].next_node = nodes[3];
  nodes[2].next_node = nodes[0];
  nodes[3].next_node = nodes[2];
  
  nodes[4].next_node = nodes[5];
  nodes[5].next_node = nodes[7];
  nodes[6].next_node = nodes[0];
  nodes[7].next_node = nodes[6];
  
  nodes[4].to_node = nodes[0].next_node;
  nodes[5].to_node = nodes[1].next_node;
  nodes[6].to_node = nodes[2].next_node;
  nodes[7].to_node = nodes[3].next_node;
  nodes[4].from_node = nodes[0];
  nodes[5].from_node = nodes[1];
  nodes[6].from_node = nodes[2];
  nodes[7].from_node = nodes[3];
}

void createOne(Node[] nodes, Node[] frames, int side, int up) {
  nodes[0] = new Node(new PVector(side, side+up, side));
  
  frames[0] = new Node(new PVector(side, side+up, side));
  frames[1] = new Node(new PVector(side, -side+up, side));
  frames[2] = new Node(new PVector(side, side+up, -side));
  frames[3] = new Node(new PVector(side, -side+up, -side));
  frames[4] = new Node(new PVector(-side, side+up, side));
  frames[5] = new Node(new PVector(-side, -side+up, side));
  frames[6] = new Node(new PVector(-side, side+up, -side));
  frames[7] = new Node(new PVector(-side, -side+up, -side));
  
  frames[0].next_node = nodes[1];
  frames[1].next_node = nodes[3];
  frames[2].next_node = nodes[6];
  frames[3].next_node = nodes[2];
  
  frames[4].next_node = nodes[5];
  frames[5].next_node = nodes[7];
  frames[6].next_node = nodes[0];
  frames[7].next_node = nodes[6];
  
  nodes[0].to_node = frames[0].next_node;
  nodes[0].from_node = frames[0];
}

void createTwo(Node[] nodes, Node[] frames, int side, int up) {
  nodes[0] = new Node(new PVector(side, side+up, side));
  nodes[1] = new Node(new PVector(side, -side+up, side));
  
  frames[0] = new Node(new PVector(side, side+up, side));
  frames[1] = new Node(new PVector(side, -side+up, side));
  frames[2] = new Node(new PVector(side, side+up, -side));
  frames[3] = new Node(new PVector(side, -side+up, -side));
  frames[4] = new Node(new PVector(-side, side+up, side));
  frames[5] = new Node(new PVector(-side, -side+up, side));
  frames[6] = new Node(new PVector(-side, side+up, -side));
  frames[7] = new Node(new PVector(-side, -side+up, -side));
  
  frames[0].next_node = nodes[1];
  frames[1].next_node = nodes[3];
  frames[2].next_node = nodes[6];
  frames[3].next_node = nodes[2];
  
  frames[4].next_node = nodes[5];
  frames[5].next_node = nodes[7];
  frames[6].next_node = nodes[0];
  frames[7].next_node = nodes[6];
  
  nodes[0].to_node = frames[0].next_node;
  nodes[0].from_node = frames[0];
  nodes[1].to_node = frames[1].next_node;
  nodes[1].from_node = frames[1];
}

void createFour(Node[] nodes, Node[] frames, int side, int up) {
  nodes[0] = new Node(new PVector(side, side+up, side));
  nodes[1] = new Node(new PVector(side, -side+up, side));
  nodes[2] = new Node(new PVector(side, side+up, -side));
  nodes[3] = new Node(new PVector(side, -side+up, -side));
  
  frames[0] = new Node(new PVector(side, side+up, side));
  frames[1] = new Node(new PVector(side, -side+up, side));
  frames[2] = new Node(new PVector(side, side+up, -side));
  frames[3] = new Node(new PVector(side, -side+up, -side));
  frames[4] = new Node(new PVector(-side, side+up, side));
  frames[5] = new Node(new PVector(-side, -side+up, side));
  frames[6] = new Node(new PVector(-side, side+up, -side));
  frames[7] = new Node(new PVector(-side, -side+up, -side));
  
  frames[0].next_node = nodes[1];
  frames[1].next_node = nodes[3];
  frames[2].next_node = nodes[6];
  frames[3].next_node = nodes[2];
  
  frames[4].next_node = nodes[5];
  frames[5].next_node = nodes[7];
  frames[6].next_node = nodes[0];
  frames[7].next_node = nodes[6];
  
  nodes[0].to_node = frames[0].next_node;
  nodes[0].from_node = frames[0];
  nodes[1].to_node = frames[1].next_node;
  nodes[1].from_node = frames[1];
  nodes[2].to_node = frames[2].next_node;
  nodes[2].from_node = frames[2];
  nodes[3].to_node = frames[3].next_node;
  nodes[3].from_node = frames[3];
}

void createTetrahedron(Node[] nodes, Node[] frames, int side_len, int up) { 
  nodes[0] = new Node(new PVector(side_len*sqrt(8/9), 0+up, -(side_len)/3));
  nodes[1] = new Node(new PVector(-side_len*sqrt(2/9), side_len*sqrt(2/3)+up, -(side_len)/3));
  nodes[2] = new Node(new PVector(-side_len*sqrt(2/9), -side_len*sqrt(2/3)+up, -(side_len)/(3)));
  nodes[3] = new Node(new PVector(0, up, -side_len));
  
  frames[0] = new Node(new PVector(side_len*sqrt(8/9), 0+up, -(side_len)/3));
  frames[1] = new Node(new PVector(-side_len*sqrt(2/9), side_len*sqrt(2/3)+up, -(side_len)/3));
  frames[2] = new Node(new PVector(-side_len*sqrt(2/9), -side_len*sqrt(2/3)+up, -(side_len)/(3)));
  frames[3] = new Node(new PVector(0, up, -side_len));
  
  frames[0].next_node = frames[1];
  frames[1].next_node = frames[2];
  frames[2].next_node = frames[3];
  frames[3].next_node = frames[0];

  nodes[0].to_node = frames[0].next_node;
  nodes[1].to_node = frames[1].next_node;
  nodes[2].to_node = frames[2].next_node;
  nodes[3].to_node = frames[3].next_node;
  nodes[0].from_node = frames[0];
  nodes[1].from_node = frames[1];
  nodes[2].from_node = frames[2];
  nodes[3].from_node = frames[3];
}

void createNodes(Node[][] nodes, Node[][] frames) {
  createTetrahedron(nodes[0], frames[0], 20, 50);
  createCubeInCube(nodes[1], 20, 50);
  /*
  nodes[0][0] = new Node(new PVector(20.0, -100.0, 20.0));
  nodes[0][1] = new Node(new PVector(-20.0, -100.0, 20.0));

  nodes[0][1].connections.add(nodes[0][0]);
  
  frame[0][0] = new Node(new PVector(20.0, -100.0, 20.0));
  frame[0][1] = new Node(new PVector(-20.0, -100.0, 20.0));
  frame[0][2] = new Node(new PVector(20.0, -100.0, -20.0));
  frame[0][3] = new Node(new PVector(-20.0, -100.0, -20.0));
  
  frame[0][0].next_node = frame[0][1];
  frame[0][1].next_node = frame[0][3];
  frame[0][2].next_node = frame[0][0];
  frame[0][3].next_node = frame[0][2];

  nodes[0][0].to_node = frame[0][0].next_node;
  nodes[0][1].to_node = frame[0][1].next_node;
  nodes[0][0].from_node = frame[0][0];
  nodes[0][1].from_node = frame[0][1];
  
  nodes[1][0] = new Node(new PVector(20.0, -100.0, 20.0));
  nodes[1][1] = new Node(new PVector(-20.0, -100.0, 20.0));
  nodes[1][2] = new Node(new PVector(20.0, -100.0, -20.0));
  nodes[1][3] = new Node(new PVector(-20.0, -100.0, -20.0));
  
  nodes[1][0].connections.add(nodes[1][1]);
  nodes[1][0].connections.add(nodes[1][2]);
  nodes[1][1].connections.add(nodes[1][3]);
  nodes[1][2].connections.add(nodes[1][3]);
  
  frame[1][0] = new Node(new PVector(20.0, -100.0, 20.0));
  frame[1][1] = new Node(new PVector(-20.0, -100.0, 20.0));
  frame[1][2] = new Node(new PVector(20.0, -100.0, -20.0));
  frame[1][3] = new Node(new PVector(-20.0, -100.0, -20.0));
  frame[1][4] = new Node(new PVector(20.0, -140.0, 20.0));
  frame[1][5] = new Node(new PVector(-20.0, -140.0, 20.0));
  frame[1][6] = new Node(new PVector(20.0, -140.0, -20.0));
  frame[1][7] = new Node(new PVector(-20.0, -140.0, -20.0));
  
  frame[1][0].next_node = frame[1][1];
  frame[1][1].next_node = frame[1][3];
  frame[1][2].next_node = frame[1][0];
  frame[1][3].next_node = frame[1][7];
  frame[1][4].next_node = frame[1][5];
  frame[1][5].next_node = frame[1][0];
  frame[1][6].next_node = frame[1][4];
  frame[1][7].next_node = frame[1][6];

  nodes[1][0].to_node = frame[1][0].next_node;
  nodes[1][1].to_node = frame[1][1].next_node;
  nodes[1][2].to_node = frame[1][2].next_node;
  nodes[1][3].to_node = frame[1][3].next_node;
  nodes[1][0].from_node = frame[1][0];
  nodes[1][1].from_node = frame[1][1];
  nodes[1][2].from_node = frame[1][2];
  nodes[1][3].from_node = frame[1][3];
*/
}
