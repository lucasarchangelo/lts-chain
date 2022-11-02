import { Button, Card, Col, Container, Row } from "react-bootstrap";
import Layout from "../../components/Layout";

const LIST_NFT = [
  {
    title: "Comon ticket",
    text: "You can use your NFT to participate to every lottery we have.",
    expire: "This ticket will expire in 1 month",
    image: "ticket_comon.png",
  },
  {
    title: "Uncommon ticket",
    text: "You can use your NFT to participate to every lottery we have.",
    expire: "This ticket will expire in 2 month",
    image: "ticket_uncommon.png",
  },
  {
    title: "Rare ticket",
    text: "You can use your NFT to participate to every lottery we have.",
    expire: "This ticket will expire in 3 month",
    image: "ticket_rare.png",
  },
  {
    title: "Epic ticket",
    text: "You can use your NFT to participate to every lottery we have.",
    expire: "This ticket will expire in 5 month",
    image: "ticket_epic.png",
  },
];

function Index() {

  const renderCard = (card: any) => {
    return (
      <Card className="card_site">
        <Card.Img variant="top" src={`/img/${card.image}`} />
        <Card.Body>
          <Card.Title>{card.title}</Card.Title>
          <Card.Text>{`${card.text} ${card.expire}`}</Card.Text>
          <Button variant="primary">Buy Ticket</Button>
        </Card.Body>
      </Card>
    );
  };

  return (
    <Layout>
      <div className="content_site">
        <Container>
          <Row>
            <Col sm={12} md={6}>
              <p className="home_text">
                Tickets NFT grant you access to all features we have, like
                lotteries and games.
                <br />
                Here some options we have:
              </p>
              <p className="home_text"></p>
              <ul className="text_site_color">
                <li>Comom tickets</li>
                <li>Uncomom tickets</li>
                <li>Rare tickets</li>
                <li>Epic tickets</li>
              </ul>
            </Col>
            <Col sm={12} md={6}>
              <Row>
                {LIST_NFT.map((card) => (
                  <Col key={card.title} sm={12} md={6}>
                    {renderCard(card)}
                  </Col>
                ))}
              </Row>
            </Col>
          </Row>
        </Container>
      </div>
    </Layout>
  );
}

export default Index;
