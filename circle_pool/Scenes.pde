
void createTetrahedron(int side_len, int i) {
  nodes[i] = new Node[4];
  frame[i] = new Node[4];
  int up = -50;
  
  nodes[i][0] = new Node(new PVector(side_len*sqrt(8/9), 0+up, -(side_len)/3));
  nodes[i][1] = new Node(new PVector(-side_len*sqrt(2/9), side_len*sqrt(2/3)+up, -(side_len)/3));
  nodes[i][2] = new Node(new PVector(-side_len*sqrt(2/9), -side_len*sqrt(2/3)+up, -(side_len)/(3)));
  nodes[i][3] = new Node(new PVector(0, up, -side_len));
  
  frame[i][0] = new Node(new PVector(side_len*sqrt(8/9), 0+up, -(side_len)/3));
  frame[i][1] = new Node(new PVector(-side_len*sqrt(2/9), side_len*sqrt(2/3)+up, -(side_len)/3));
  frame[i][2] = new Node(new PVector(-side_len*sqrt(2/9), -side_len*sqrt(2/3)+up, -(side_len)/(3)));
  frame[i][3] = new Node(new PVector(0, up, -side_len));
  
  frame[i][0].next_node = frame[2][1];
  frame[i][1].next_node = frame[2][2];
  frame[i][2].next_node = frame[2][3];
  frame[i][3].next_node = frame[2][0];

  nodes[i][0].to_node = frame[i][0].next_node;
  nodes[i][1].to_node = frame[i][1].next_node;
  nodes[i][2].to_node = frame[i][2].next_node;
  nodes[i][3].to_node = frame[i][3].next_node;
  nodes[i][0].from_node = frame[i][0];
  nodes[i][1].from_node = frame[i][1];
  nodes[i][2].from_node = frame[i][2];
  nodes[i][3].from_node = frame[i][3];
  
  
}

void createNodes() {
  nodes[0] = new Node[2];
  nodes[1] = new Node[4];
  nodes[2] = new Node[4];
//  nodes[3] = new Node[16];

  frame[0] = new Node[4];
  frame[1] = new Node[8];
//  frame[2] = new Node[4];
//  frame[4] = new Node[4];

  createTetrahedron(40, 2);

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
}
