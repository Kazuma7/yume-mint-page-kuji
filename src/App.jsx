import "./App.css";
import { useEffect, useState } from "react";
import { ethers } from "ethers";
import SimpleStorage_abi from "./contracts/SimpleStorage_abi.json";
import YumeHeader from "./YumeHeader";
import YumeFooter from "./YumeFooter";

const App = () => {
  const [mintNum, setMintNum] = useState(null);

  const contractAddress = "0xd8010F6AdFDf084cd31c04B9CaF93737F43E8764";

  useEffect(() => {
    const setSaleInfo = async () => {
      //メタマスクと接続することでコントラクトにアクセスできるようになる
      const account = await window.ethereum.request({
        method: "eth_requestAccounts",
      });

      const provider = new ethers.providers.Web3Provider(window.ethereum);
      const signer = provider.getSigner();
      const contract = new ethers.Contract(
        contractAddress,
        SimpleStorage_abi,
        signer
      );

      try {
        const mintNumber = (await contract.getSupply()).toString();
        console.log("mintNumber", mintNumber);
        setMintNum(mintNumber);
      } catch (e) {
        console.log(e);
      }
    };
    setSaleInfo();
  }, []);

  const buy = async () => {
    const provider = new ethers.providers.Web3Provider(window.ethereum);
    const account = await provider.send("eth_requestAccounts", []);
    const signer = provider.getSigner();
    const contract = new ethers.Contract(
      contractAddress,
      SimpleStorage_abi,
      signer
    );
    await contract.mint();
  };

  return (
    <div className="App">
      <YumeHeader />

      <div className="flex justify-center my-10 flex-wrap">
        <div className="h-60 w-60 shadow-md linkbox">
          <a href="https://kazuma-i.notion.site/be324ef4df2b4382b831f000e675bcc2"></a>
          <div className="text-7xl mt-14">📚</div>
          <div className="pt-5 font-bold text-gray-800">このページの使い方</div>
        </div>
        <div className="h-60 w-60 shadow-md lg:ml-6 linkbox">
          <a href="https://kazuma-i.notion.site/d7ce1a62144c42b8a6a1b172f850268b"></a>
          <div className="text-7xl mt-14">✏️</div>
          <div className="pt-5 font-bold text-gray-800">
            これまでの勉強会内容
          </div>
        </div>
        <div className="h-60 w-60 shadow-md lg:ml-6 linkbox">
          <a href="https://docs.google.com/forms/d/e/1FAIpQLSdXg7J0ZhhxUizBJ394AkET1sJuz4Y7nqj35sDYbth-Ork4JA/viewform?usp=sf_link"></a>
          <div className="text-7xl mt-14">📄</div>
          <div className="pt-5 font-bold text-gray-800">アンケート</div>
        </div>
      </div>

      <div className="w-96 h-32 flex justify-center items-center border-2 mx-auto mb-10">
        <div>
          <div className="mb-2">これまでのNFT発行数</div>
          <div className="text-xl yumemi-text">{mintNum} / 1000</div>
        </div>
      </div>

      <button
        onClick={buy}
        className="px-8 gradation-background text-white font-bold rounded-md py-3 text-lg yumemi-text"
      >
        mint
      </button>

      <YumeFooter />
    </div>
  );
};

export default App;
