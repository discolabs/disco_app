import * as dateFormat from 'dateformat';
import numeral from 'numeral';

export const numberToCurrency = amount => {
  const format = '$0,0.00';
  const floatAmount = parseFloat(amount);

  if (floatAmount < 0) {
    return `(${numeral(Math.abs(floatAmount)).format(format)})`;
  }

  return numeral(floatAmount).format(format);
};

export const strftime = (date, format) => dateFormat(date, format);
