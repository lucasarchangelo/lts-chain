import { useState } from "react";
import Image from "next/image";
import { Container, Row, Col } from "react-bootstrap";
import Layout from "../components/Layout";

const Home = () => {
  const [accounts, setAccounts] = useState(Array<string>);
  const [connected, setConnected] = useState(false);

  return (
    <Layout>
      <div className="content_site">
        <Container fluid="md">
          <Row>
            <Col>
              <p className="home_title">
                Come with us, and see the best Cryptoverse project growing up.
              </p>
              <p className="home_text">
                Start buying your NFT to get access to our project.{" "}
                <a href="/">Click here.</a>
              </p>
            </Col>
            <Col>
              <Image alt="" src="/logo512.png" width={300} height={300}></Image>
            </Col>
          </Row>
        </Container>
      </div>
    </Layout>
  );
}

export default Home;
