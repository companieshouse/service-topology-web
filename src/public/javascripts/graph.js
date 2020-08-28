let journey = 'all';
let availableJourneys = ['all']

// controls
let controls = { 'Loading': 'all' };
const gui = new dat.GUI();
gui.add(controls, 'Loading', availableJourneys)
  .onChange(journey => setData(journey));

let gData = {
  "nodes": [],
  "links": []
};

function crossLinkNodes() {
  // cross-link node objects
  gData.links.forEach(link => {
    let a;
    let b;
    gData.nodes.forEach(node => {
      if (node.id === link.source) {
        a = node;
      }
      if (node.id === link.target) {
        b = node;
      }
    })
    !a.neighbors && (a.neighbors = []);
    !b.neighbors && (b.neighbors = []);
    a.neighbors.push(b);
    b.neighbors.push(a);

    !a.links && (a.links = []);
    !b.links && (b.links = []);
    a.links.push(link);
    b.links.push(link);
  });
}

const highlightNodes = new Set();
const highlightLinks = new Set();
let hoverNode = null;

const Graph = ForceGraph3D()
    .nodeThreeObject(node => {
      // use a sphere as a drag handle
      const obj = new THREE.Mesh(
        new THREE.SphereGeometry(4,32,32),
        new THREE.MeshStandardMaterial({ color: '#'+Math.random().toString(16).substr(-6), emissive: 0x42423e, metalness: 0.5, roughness: 0.5})
      );

      // add text sprite as child
      const sprite = new SpriteText(node.name);
      sprite.color = 'white';
      sprite.textHeight = 3;
      sprite.position.x = 5;
      sprite.position.y = 7;
      obj.add(sprite);

      return obj;
    })
    .linkWidth(link => highlightLinks.has(link) ? 2 : 1)
    .linkDirectionalParticles(link => highlightLinks.has(link) ? 2 : 0)
    .linkDirectionalParticleWidth(2)
    .onNodeHover(node => {
      // no state change
      if ((!node && !highlightNodes.size) || (node && hoverNode === node)) return;

      highlightNodes.clear();
      highlightLinks.clear();
      if (node) {
        highlightNodes.add(node);
        node.neighbors.forEach(neighbor => highlightNodes.add(neighbor));
        node.links.forEach(link => highlightLinks.add(link));
      }

      hoverNode = node || null;

      updateHighlight();
    })
    .onLinkHover(link => {
      highlightNodes.clear();
      highlightLinks.clear();

      if (link) {
        highlightLinks.add(link);
        highlightNodes.add(link.source);
        highlightNodes.add(link.target);
      }

      updateHighlight();
    });

function updateHighlight() {
  // trigger update of highlighted objects in scene
  Graph
    .nodeColor(Graph.nodeColor())
    .linkWidth(Graph.linkWidth())
    .linkDirectionalParticles(Graph.linkDirectionalParticles());
}

async function getData(journey) {

  await axios.get('/network?journey=' + journey)
    .then((resp) => {
      if (resp.status === 200) {
        gData = resp.data
      }
    })
}

function getJourneys() {

  axios.get('/journeys')
    .then((resp) => {
      if (resp.status === 200) {
        availableJourneys = resp.data
        var controller = gui.__controllers[0];
        controller.remove();
        controls = { 'Journey': 'all' };
        gui.add(controls, 'Journey', availableJourneys)
          .onChange(journey => setData(journey));
        gui.__controllers[0].updateDisplay();
      }
    })
}

async function setData(journey) {

  await getData(journey);
  await crossLinkNodes();
  Graph.graphData(gData);
}

(async function() {
  getJourneys();
  await getData(journey);
  await crossLinkNodes();
  Graph(document.getElementById('3d-graph'))
    .graphData(gData);
})();
