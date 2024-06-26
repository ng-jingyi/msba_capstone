library(data.table)
library(tidyverse)
library(bupaverse)

dt <- fread('sample_freq_sequences_52_52.csv')

event_dict <- fread('spm_seq_grouped_data_event_dict.csv')
event_dict[, event_num := as.character(event_num)]
dt[, sequence := as.character(sequence)]
event_log <- merge(dt, event_dict, by.x = 'sequence', by.y = 'event_num', all.x = T)

# Create event log
start_time <- ymd_hms("2023-01-01 00:00:00")


event_log[, `:=` (lifecycle_id = 'complete',
                  resource_id = NA,
                  activity_instance_id = .I,
                  timestamp = start_time + seconds(1:.N - 1))]

event_log[, `:=` (session_id = as.character(session_id),
                  activity_instance_id = as.character(activity_instance_id))]


event_log <- eventlog(eventlog = event_log,
                      case_id = 'session_id',
                      activity_id = 'event',
                      activity_instance_id = 'activity_instance_id',
                      lifecycle_id = 'lifecycle_id',
                      timestamp = 'timestamp',
                      resource_id = 'resource_id')

event_log <- event_log[, c("session_id", "event", "lifecycle_id", "resource_id", "activity_instance_id", "timestamp", ".order")]

str(event_log)

event_log %>%
  # filter_infrequent_flows(min_n = 15) %>%
  process_map(frequency('absolute'), fixed_edges = TRUE, fixed_nodes = TRUE, rankdir = "LR") 

to_save <- event_log %>%
  # filter_infrequent_flows(min_n = 15) %>%
  process_map(frequency('absolute'), fixed_edges = TRUE, fixed_nodes = TRUE, rankdir = "LR", render = F) 

export_map(to_save, file_name = 'process_map_52_52.png', height = 8000, width = 8000)
