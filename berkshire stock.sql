-- performance over time
select 
    strftime('%Y', `date`) as year,
    avg(`close`) as avg_close_price,
    sum(`volume`) as total_volume
from 
    `brk-a`
group by 
    year
order by 
    year asc;

-- volatility analysis
select 
    `date`,
    (`high` - `low`) / `low` * 100 as price_fluctuation_percent
from 
    `brk-a`
where 
    (`high` - `low`) / `low` * 100 > 5
order by 
    price_fluctuation_percent desc;

-- dividend and stock split information
select 
    `date`, 
    `adjClose`, 
    `volume`
from 
    `brk-a`
where 
    `adjClose` > 0
order by 
    `date` asc;

-- peak trading volume days
select 
    `date`, 
    `volume`
from 
    `brk-a`
where 
    `volume` = (select max(`volume`) from `brk-a`)
order by 
    `volume` desc;

-- long-term moving averages
select 
    `date`, 
    avg(`close`) over (order by `date` rows between 199 preceding and current row) as `200_day_moving_avg`
from 
    `brk-a`
order by 
    `date` asc;

-- identify bull and bear markets
select 
    `date`,
    case 
        when `close` > lag(`close`, 5) over (order by `date`) then 'Bull Market'
        when `close` < lag(`close`, 5) over (order by `date`) then 'Bear Market'
        else 'Neutral'
    end as market_condition
from 
    `brk-a`
order by 
    `date` asc;

-- most profitable months
select 
    strftime('%m', `date`) as month,
    avg(`close`) as avg_close_price
from 
    `brk-a`
group by 
    month
order by 
    avg_close_price desc;

-- price and volume correlation
select 
    `date`, 
    `close`, 
    `volume`
from 
    `brk-a`
where 
    `volume` = (select max(`volume`) from `brk-a`) or `volume` = (select min(`volume`) from `brk-a`)
order by 
    `date` asc;
