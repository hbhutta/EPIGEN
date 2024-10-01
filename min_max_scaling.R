

# This script was used for scaling the feature importances obtained by iRF

min_max_scale <- function(x) {
  (x - min(x)) / (max(x) - min(x))
}

# Stages
stages <- c('esc', 'hp', 'he', 'hp')

# Number of iterations/equations for each dataset
esc_num_iter <- 8 # Stage 1
hb_num_iter <- 7 # Stage 2
he_num_iter <- 8 # Stage 3
hp_num_iter <- 9 # Stage 4

# Features tracked in each stage's system
esc_features <- c('ESC_positive_enhancer',
                  'esc_active',
                  'esc_dnasei',
                  'esc_rna',
                  'esc_esrrb',
                  'esc_nanog',
                  'esc_pou5f1',
                  'esc_sox2')

hb_features <- c('HB_positive_enhancer',
                 'hb_active',
                 'hb_dnasei',
                 'hb_rna',
                 'hb_cebp',
                 'hb_lmo2',
                 'hb_tal1')

he_features <- c('HE_positive_enhancer',
                 'he_active',
                 'he_dnasei',
                 'he_rna',
                 'he_cebp',
                 'he_tal1',
                 'he_fli1',
                 'he_meis1')


hp_features <- c('HP_positive_enhancer',
                 'hp_active',
                 'hp_dnasei',
                 'hp_rna',
                 'hp_cebp',
                 'hp_tal1',
                 'hp_fli1',
                 'hp_spi1',
                 'hp_runx1')



base_dir_path <- 'C:\\Users\\haadb\\OneDrive\\Desktop\\School\\EPIGEN\\my_epigen_work\\scripts\\' # e.g. ...  + /hb/hb_active_fit.Rdata

for (stage in stages) {
  print(paste0('In stage: ', stage))
  stage_matrix <- NULL
  for (feature in get0(paste0(stage, '_features'))) {
    print(paste0('Getting importances of feature: ', feature))
    stage_feature_fit_path <- paste0(base_dir_path, stage, '\\', feature, '_fit_new.Rdata')
    print(stage_feature_fit_path)
    load(stage_feature_fit_path)
    print(paste0('Loaded fit .Rdata for: ', feature))
    stage_matrix <- rbind(
      stage_matrix, 
      min_max_scale(get0(paste0(feature, '_fit'))[["rf.list"]][[get0(paste0(stage, '_num_iter'))]][["importance"]])
    )
  }
  final_matrix <- stage_matrix
  write.csv(t(final_matrix), file = paste0(base_dir_path, stage, '//', paste0(stage, '_normalized_importances_matrix_final_last_five.csv')))
  print(paste0(base_dir_path, stage, '//', paste0(stage, '_normalized_importances_matrix_final.csv')))
}

