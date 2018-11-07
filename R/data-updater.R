# this script 'updates' the raw kaggle data and only makes minimal 
# enhancements. Mainly, making the dataset seem like it could come
# out of a real-life banking transaction system. Two datasets come out of
# this process::
#
#  1. ABT: a data set ready for exploration; a timestamp will be added and
#          feature names will be cleaned up to abide by best practices
#
#  2. TODO: (edges/links) for network analysis

# libraries
suppressPackageStartupMessages(library(readr))
suppressPackageStartupMessages(library(dplyr))

# transactions ------------------------------------------------------------
if (!file.exists("data/bs140513_032310.csv")) {
  stop("the data () cannot be located in the `data/` directory. Did you run
        the `get-data.sh` shell script?")
} else if (file.exists("data/transactions.csv")) {
    message("transactions datasets already exist. Exiting now.")
} else {
  
  message("preparing data-set ... ")
  
  # read in the dataset
  tmp_data <- suppressMessages(
    readr::read_csv("data/bs140513_032310.csv")
  )
  
  # create a timestamp from each unique step; we're going to assume that each
  # step corresponds to one day
  min_step <- with(tmp_data, min(step))
  max_step <- with(tmp_data, max(step))
  
  start_dt <- as.Date("2018/01/23")
  end_dt <- start_dt + max_step
  date_seq <- seq.Date(start_dt, end_dt, by="days")
  
  dt_tbl <- data.frame(
    step = seq(min_step, max_step, by=1), 
    transaction_dt = date_seq
  )
  
  # join-in the new time-stamp variable
  tmp_data <- dplyr::inner_join(tmp_data, dt_tbl, by="step") %>%
    dplyr::select(step, transaction_dt, dplyr::everything())
  
  # remove the leading/ending tick marks for every character column
  tmp_data <- tmp_data %>% 
    dplyr::mutate_if(is.character, function(col) {
      gsub(pattern = "'", replacement = "" , col)
    })
  
  # fix column names to all be snake-case
  tmp_data <- tmp_data %>% 
    dplyr::rename(
      zip_code_ori = zipcodeOri,
      zip_merchant = zipMerchant
    )
  
  # we will turn our dates into true-timestamps. We will include some
  # noise to make sure that there is some variability in the time-stamp (this
  # will be normally destributed, with a mean time of 8:00 am). Time-zone will
  # be UTC
  set.seed(1337)
  utc_ts <- with(tmp_data, as.POSIXlt(paste(transaction_dt, "13:00:00"), tz="UTC"))
  utc_ts <- utc_ts + rnorm(n = length(utc_ts), mean = 0, sd = 60*60)
  
  tmp_data <- tmp_data %>%
    dplyr::mutate(transaction_ts = utc_ts) %>%
    dplyr::select(transaction_dt, transaction_ts, dplyr::everything())

  # lastly, partition a part of the data to hold-out as part of a demo; that is,
  # we're going to pretend this data will _stream_ in at some point in the
  # future. We'll hold-off all transactions after 2018-07-07 
  data <- tmp_data %>% 
    dplyr::filter(transaction_dt <= "2018-07-07")
  
  future_data <-tmp_data %>% 
    dplyr::filter(transaction_dt > "2018-07-07")
  
  # write the datasets to data/ directory
  if (!file.exists("data/transactions.csv")) {
    message("writing datasets to `data/` ... ")
    readr::write_csv(data, "data/transactions.csv")
    readr::write_csv(future_data, "data/transactions_future_dates.csv")
    message("complete!")
  } else {
    message("transactions datasets already exist. Exiting now.")
  }
}

# nodes-edges -------------------------------------------------------------

# coming soon! 