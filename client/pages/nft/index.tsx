import { useEffect, useState } from "react";
import { Button, Card, Col, Container, Row } from "react-bootstrap";
import Layout from "../../components/Layout";
import { Web3Helper, Web3Object } from "../../helpers/web3_helper";

let LIST_NFT = [
  {
    title: "Comon ticket",
    text: "You can use your NFT to participate to every lottery we have.",
    price: "0.004 ETH",
    image: "ticket_comon.png",
  },
  {
    title: "Uncommon ticket",
    text: "You can use your NFT to participate to every lottery we have.",
    price: "0.009 ETH",
    image: "ticket_uncommon.png",
  },
  {
    title: "Rare ticket",
    text: "You can use your NFT to participate to every lottery we have.",
    price: "0.012 ETH",
    image: "ticket_rare.png",
  },
  {
    title: "Epic ticket",
    text: "You can use your NFT to participate to every lottery we have.",
    price: "0.05 ETH",
    image: "ticket_epic.png",
  },
];

function Index() {
  const [accounts, setAccounts] = useState(Array<string>);
  const [prices, setPrices] = useState(Array<string>);

  useEffect(() => {
    startSubject();
  }, []);

  const startSubject = async () => {
    Web3Helper.Instance.web3Objects.subscribe(async (result: Web3Object) => {
      setAccounts(result.accounts);
      const prices = await getAllPrices();
      setPrices(prices);
      let i = 0;
      LIST_NFT = LIST_NFT.map((element) => {
        return {
          price: `Price: ${result.web3.utils.fromWei(
            prices[i++],
            "ether"
          )} BNB`,
          title: element.title,
          text: element.text,
          image: element.image,
        };
      });
    });
  };

  const getAllPrices = async () => {
    return await Web3Helper.Instance.getSaleInstance()
      .methods.getAllPrices()
      .call();
  };

  const buyNFT = (index: number) => async () => {
    switch (index) {
      case 0:
        Web3Helper.Instance.getSaleInstance()
          .methods.purchasecommon()
          .send({ from: accounts[0], value: prices[0]});
        break;
      case 1:
        Web3Helper.Instance.getSaleInstance()
          .methods.purchaseUncommon()
          .send({ from: accounts[0], value: prices[1]});
        break;
      case 2:
        Web3Helper.Instance.getSaleInstance()
          .methods.purchaseRare()
          .send({ from: accounts[0], value: prices[2]});
        break;
      case 3:
        Web3Helper.Instance.getSaleInstance()
          .methods.purchaseEpic()
          .send({ from: accounts[0], value: prices[3]});
        break;
      default:
        Web3Helper.Instance.getSaleInstance()
          .methods.purchasecommon()
          .send({ from: accounts[0] });
        break;
    }
  };

  const renderCard = (card: any, index: number) => {
    return (
      <Card className="card_site">
        <Card.Img variant="top" src={`/img/${card.image}`} />
        <Card.Body>
          <Card.Title>{card.title}</Card.Title>
          <Card.Text>
            {card.text}
            <br />
            {card.price}
          </Card.Text>
          <Button onClick={buyNFT(index)} variant="primary">
            Buy Ticket
          </Button>
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
                <li>Uncomom Tickets</li>
                <li>Rare tickets</li>
                <li>Epic tickets</li>
              </ul>
            </Col>
            <Col sm={12} md={6}>
              <Row>
                {LIST_NFT.map((card, index) => (
                  <Col key={index} sm={12} md={6}>
                    {renderCard(card, index)}
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
