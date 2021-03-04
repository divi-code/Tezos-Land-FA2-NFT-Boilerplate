import styled from 'styled-components/macro'
import { GridPage } from 'styles';

export const BuyStyled = styled(GridPage)`
`;

export const BuyLandStyled = styled.div`
  position: relative;
  width: 230px;
`;


export const BuyLandBottom = styled.div`
  background-color: #141b43;
  padding: 10px;
  border-radius: 0 0 10px 10px;
`;

export const BuyLandFirstRow = styled.div`
  display: grid;
  grid-template-columns: 50px auto;
  grid-gap: 10px;
`;

export const BuyLandSecondRow = styled.div`
  position: relative;
  margin-top: 8px;
  width: 500px;
`;

export const BuyLandThirdRow = styled.div`
  position: relative;
  margin-top: 8px;
  width: 500px;
`;


export const BuyLandFourthRow = styled.div`
  margin-top: 10px;
`;

export const BuyLandLocation = styled.div`
  height: 20px;
  width: 50px;
  line-height: 20px;
  border-radius: 5px;
  background-color: #4c5170;
  > svg {
    display: inline-block;
    width: 12px;
    height: 12px;
    margin: 4px;
    stroke: white;
  }
  > div {
    display: inline-block;
    font-size: 11px;
    vertical-align: super;
    line-height: 17px;
    margin-left: 3px;
  }
`;

export const BuyLandOwner = styled.div`
display: grid;
  grid-template-columns: 20px auto;
  height: 20px;
  width: 210px;
  line-height: 20px;
  border-radius: 5px;
  background-color: #4c5170;
  > svg {
    display: inline-block;
    width: 12px;
    height: 12px;
    margin: 4px;
    stroke: white;
  }
  > div {
    display: inline-block;
    font-size: 9px;
    vertical-align: super;
    line-height: 20px;
    margin-left: 3px;
  }
`;

export const BuyLandId = styled.div`
display: grid;
  grid-template-columns: 20px auto;
  height: 20px;
  width: 40px;
  line-height: 20px;
  border-radius: 5px;
  background-color: #4c5170;
  > svg {
    display: inline-block;
    width: 12px;
    height: 12px;
    margin: 4px;
    stroke: white;
  }
  > div {
    display: inline-block;
    font-size: 9px;
    vertical-align: super;
    text-align: right;
    padding-right: 5px;
    line-height: 20px;
    margin-left: 3px;
  }
`;


export const BuyLandOnSale = styled.div`
  color: #E50000;
  line-height: 20px;
  text-align: right;
  font-size: 11px;
`;

export const BuyLandButton = styled.button`
  height: 20px;
  font-size: 11px;
  width: 100%;
  background-color: #4c5170;
  box-sizing: border-box;
  border: 0;
  border-radius: 5px;
  color: #FFF;
`;