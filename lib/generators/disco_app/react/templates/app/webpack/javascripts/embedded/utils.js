import { DateTime } from 'luxon';
import numeral from 'numeral';

export const numberToCurrency = amount => {
  const format = '$0,0.00';
  const floatAmount = parseFloat(amount);

  if (floatAmount < 0) {
    return `(${numeral(Math.abs(floatAmount)).format(format)})`;
  }

  return numeral(floatAmount).format(format);
};

export const formatTime = time => {
  if (!time) return 'N/A';

  return DateTime.fromISO(time).toLocaleString(DateTime.DATETIME_SHORT);
};
