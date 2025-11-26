# Imputation

## Preliminary

``` r

## load R package
library(msDiaLogue)
## preprocessing
fileName <- "../inst/extdata/Toy_Spectronaut_Data.csv"
dataSet <- preprocessing(fileName,
                         filterNaN = TRUE, filterUnique = 2,
                         replaceBlank = TRUE, saveRm = TRUE)
## transformation
dataTran <- transform(dataSet, logFold = 2)
## normalization
dataNorm <- normalize(dataTran, normalizeType = "quant")
```

## Examples

For example, to impute the NA value of `dataNorm` using
[`impute.min_local()`](https://uconn-scs.github.io/msDiaLogue/reference/impute.min_local.md),
set the required percentage of values that must be present in a given
protein by condition combination for values to be imputed to 51%.

**Note:** There is no rule in the field of proteomics for filtering
based on percentage of missingness, similar to there being no rule for
the number of replicates required to draw a conclusion. However,
reproducible observations make conclusions more credible. Setting the
`reqPercentPresent` to 0.51 requires that any protein be observed in a
majority of the replicates by condition in order to be considered. For 3
replicates, this would require 2 measurements to allow imputation of the
3rd value. If only 1 measurement is seen, the other values will remain
NA, and will be filtered out in a subsequent step.

``` r

dataImput <- impute.min_local(dataNorm, reportImputing = FALSE,
                              reqPercentPresent = 0.51)
```

| R.Condition | R.Replicate | NUD4B_HUMAN (+1) | A0A7P0T808_HUMAN (+1) | A0A8I5KU53_HUMAN (+1) | ZN840_HUMAN | CC85C_HUMAN | TMC5B_HUMAN | C9JEV0_HUMAN (+1) | C9JNU9_HUMAN | ALBU_BOVIN | CYC_BOVIN | TRFE_BOVIN | KRT16_MOUSE | F8W0H2_HUMAN | H0Y7V7_HUMAN (+1) | H0YD14_HUMAN | H3BUF6_HUMAN | H7C1W4_HUMAN (+1) | H7C3M7_HUMAN | TCPR2_HUMAN | TLR3_HUMAN | LRIG2_HUMAN | RAB3D_HUMAN | ADH1_YEAST | LYSC_CHICK | BGAL_ECOLI | CYTA_HUMAN | KPCB_HUMAN | LIPL_HUMAN | PIP_HUMAN | CO6_HUMAN | BGAL_HUMAN | SYTC_HUMAN | CASPE_HUMAN | DCAF6_HUMAN | DALD3_HUMAN | HGNAT_HUMAN | RFFL_HUMAN | RN185_HUMAN | ZN462_HUMAN | ALKB7_HUMAN | POLK_HUMAN | ACAD8_HUMAN | A0A7I2PK40_HUMAN (+2) | NBDY_HUMAN | H0Y5R1_HUMAN (+1) |
|:---|:---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 100pmol | 1 | 10.37045 | 11.406514 | 10.956950 | 8.392426 | 8.710518 | 8.610420 | 7.829510 | 8.023133 | 16.75777 | 12.96499 | 13.97388 | 10.51096 | 9.136271 | 10.231965 | 10.048461 | 8.179306 | 8.279169 | 9.874410 | 14.201118 | 7.001503 | 8.832972 | 9.978488 | 15.16303 | 13.62766 | 14.44005 | 8.964155 | 9.574185 | 8.517979 | 6.420716 | 6.764393 | 12.07953 | 14.76033 | 6.004586 | 7.670711 | 10.129049 | 10.681337 | 7.242036 | 9.727210 | 9.376507 | 7.109682 | 7.393910 | 7.530379 | 10.370449 | NA | NA |
| 100pmol | 2 | 11.40651 | 12.964987 | 9.727210 | 8.517979 | 8.832972 | 8.710518 | 7.242036 | 8.023133 | 16.75777 | 13.62766 | 14.20112 | NA | 8.964155 | 10.048461 | 10.231965 | 7.829510 | 7.670711 | 9.574185 | 10.681337 | 7.393910 | 8.610420 | 10.129049 | 15.16303 | 13.97388 | 14.44005 | 9.136271 | 9.978488 | 8.279169 | 6.764393 | 6.420716 | 12.07953 | 14.76033 | 7.109682 | 8.179306 | 9.874410 | 10.956950 | 7.001503 | 10.370449 | 8.392426 | 6.004586 | 9.376507 | 7.530379 | 10.510962 | NA | NA |
| 100pmol | 3 | 10.32522 | 11.893804 | 10.851852 | 7.868171 | 8.887142 | 8.610420 | 6.429596 | 8.646475 | 16.75777 | 12.81909 | 13.94448 | NA | 9.027184 | 9.940284 | 9.504539 | 8.074082 | 7.698334 | 10.467264 | 14.178809 | 7.413486 | 8.433160 | 10.022816 | 15.15272 | 13.55168 | 14.42169 | 8.758911 | 9.812352 | 8.213284 | NA | 6.777937 | 11.29130 | 14.74334 | 6.004586 | 8.311138 | 9.649565 | 10.097660 | 7.009435 | 10.195272 | 8.550204 | 7.121143 | 7.262869 | 7.555404 | 10.625304 | 9.244669 | NA |
| 100pmol | 4 | 10.51096 | 12.079525 | 10.956950 | 8.279169 | 8.964155 | 8.610420 | 6.004586 | 8.023133 | 16.75777 | 12.96499 | 13.97388 | NA | 9.136271 | 10.048461 | 9.978488 | 7.829510 | 7.670711 | 9.376507 | 14.440054 | 7.829510 | 8.517979 | 10.231965 | 15.16303 | 13.62766 | 14.20112 | 8.710518 | 10.129049 | 8.179306 | NA | 7.109682 | 11.40651 | 14.76033 | 6.420716 | 7.530379 | 8.832972 | 10.681337 | 6.764393 | 9.874410 | 8.392426 | 7.001503 | 7.242036 | 7.393910 | 10.370449 | 9.727210 | 9.574185 |
| 200pmol | 1 | 10.27762 | 12.256403 | 10.413259 | 8.356482 | 7.375266 | 8.476493 | 7.098768 | 8.149770 | 16.75777 | 13.10393 | 14.00189 | 10.74088 | 9.255807 | 10.077232 | 9.798890 | 8.142561 | 7.974610 | 10.164570 | 13.700017 | 7.644405 | 8.253204 | 9.927121 | 15.17286 | 14.22236 | 14.77650 | 8.577167 | 10.010298 | 8.782531 | 6.004586 | 7.222195 | 11.51625 | 14.45755 | 6.412260 | 7.506546 | 9.641587 | 10.556023 | 6.751494 | 8.669939 | 9.040857 | 7.792691 | 6.993948 | 8.905805 | 11.057043 | NA | 9.504539 |
| 200pmol | 2 | 10.53171 | 11.078642 | 10.729201 | 8.356482 | 8.732804 | 8.476493 | 7.026553 | 8.267212 | 16.75777 | 12.49496 | 13.38772 | NA | 9.012072 | 10.120238 | 9.798890 | 8.149770 | 7.964140 | 9.954832 | 14.130668 | 7.608925 | 8.620541 | 10.229206 | 15.13045 | 13.88102 | 14.70670 | 8.866513 | 10.377729 | 8.386314 | NA | 7.145874 | 11.59517 | 14.38206 | 6.004586 | 7.766206 | 9.827232 | 9.232358 | 6.448756 | 9.504539 | 8.520402 | 6.807164 | 7.455730 | 7.307825 | 9.827232 | 10.036651 | 9.658384 |
| 200pmol | 3 | 11.05704 | 8.142561 | 12.256403 | 8.356482 | 8.905805 | 8.782531 | 6.412260 | 8.669939 | 16.75777 | 14.00189 | 13.70002 | 10.74088 | 9.255807 | 10.413259 | 10.164570 | 7.792691 | 7.506546 | 10.010298 | NA | 7.375266 | 8.476493 | 10.277619 | 15.17286 | 14.22236 | 14.77650 | 8.577167 | 9.927121 | 8.253204 | NA | 6.993948 | 13.10393 | 14.45755 | 6.004586 | 7.098768 | 10.077232 | 11.516245 | 6.751494 | 9.798890 | 9.040857 | 7.974610 | 7.222195 | 7.644405 | 10.556023 | 9.641587 | 9.504539 |
| 200pmol | 4 | 10.72920 | 8.520402 | 11.595175 | 8.732804 | 7.964140 | 9.012072 | 6.448756 | 8.149770 | 16.75777 | 13.38772 | 13.88102 | NA | 9.504539 | 9.954832 | 10.229206 | 8.267212 | 6.807164 | 10.036651 | NA | 7.455730 | 8.253204 | 10.531713 | 15.13045 | 14.13067 | 14.70670 | 9.232358 | 10.377729 | 8.386314 | NA | 7.026553 | 12.49496 | 14.38206 | 6.004586 | 7.608925 | 10.120238 | 11.078642 | 7.145874 | 9.658384 | 8.866513 | 7.766206 | 7.307825 | 8.620541 | 9.827232 | NA | 9.504539 |
| 50pmol | 1 | 10.72920 | 9.232358 | 7.766206 | 8.267212 | 8.732804 | NA | 9.658384 | 7.964140 | 16.75777 | 12.49496 | 13.88102 | NA | 9.504539 | 10.120238 | 10.377729 | 8.520402 | 7.608925 | 9.827232 | 14.130668 | 7.455730 | 8.620541 | 10.531713 | 14.70670 | 13.38772 | 14.38206 | 11.078642 | 10.229206 | 8.386314 | 10.036651 | 7.026553 | 11.59517 | 15.13045 | 9.954832 | 7.307825 | 8.298269 | 9.012072 | 6.807164 | 8.866513 | 6.448756 | 8.149770 | 6.004586 | 7.145874 | NA | NA | NA |
| 50pmol | 2 | 10.96831 | 6.004586 | 10.662903 | 8.659793 | 8.785723 | NA | 8.190682 | 8.555305 | 16.75777 | 12.30540 | 13.84672 | NA | 9.753718 | 9.581714 | 10.189464 | 8.429646 | 7.035806 | 10.008606 | 14.686886 | 7.159242 | 9.099265 | 10.482590 | 14.36063 | 13.25790 | 14.10465 | 10.086066 | 10.189464 | 8.926299 | 7.806291 | 7.637117 | 11.47571 | 15.11842 | 8.017625 | 7.480137 | 8.298269 | 10.329078 | 6.459113 | 9.911682 | 9.362666 | 7.332126 | 6.004586 | 6.822962 | NA | NA | NA |
| 50pmol | 3 | 11.59517 | 6.004586 | 10.729201 | 6.448756 | 8.732804 | 9.232358 | 8.149770 | 8.386314 | 16.75777 | 13.38772 | 14.13067 | 11.07864 | 9.658384 | 9.362666 | 10.377729 | 8.620541 | 7.026553 | 9.954832 | 9.827232 | 7.035806 | 8.429646 | 10.531713 | 14.70670 | 13.88102 | 14.38206 | 10.036651 | 10.229206 | 9.012072 | 7.608925 | 7.455730 | 12.49496 | 15.13045 | 7.964140 | 7.766206 | 8.520402 | 10.120238 | 7.145874 | 9.504539 | 8.267212 | 8.866513 | 7.307825 | 6.807164 | NA | NA | NA |
| 50pmol | 4 | 10.96831 | 10.008606 | 10.662903 | 8.298269 | 8.190682 | 8.785723 | 7.806291 | 8.659793 | 16.75777 | 12.30540 | 13.84672 | NA | 9.504539 | 9.362666 | 10.482590 | 8.555305 | 6.004586 | 9.753718 | 14.360635 | 7.035806 | 8.429646 | 10.329078 | 14.68689 | 13.25790 | 14.10465 | 9.911682 | 10.189464 | 8.386314 | 7.332126 | 7.026553 | 11.47571 | 15.11842 | 7.637117 | 8.017625 | 9.581714 | 10.086066 | 6.459113 | 9.099265 | 8.926299 | 7.480137 | 7.159242 | 6.822962 | NA | NA | NA |

If `reportImputing = TRUE`, the returned result structure will be
altered to a list, adding a shadow data frame with imputed data labels,
where 1 indicates the corresponding entries have been imputed, and 0
indicates otherwise.

After the above imputation, any entries that did not pass the percent
present threshold will still have NA values and will need to be filtered
out.

``` r

dataImput <- filterNA(dataImput, saveRm = TRUE)
```

where `saveRm = TRUE` indicates that the filtered data will be saved as
a .csv file named *filtered_NA_data.csv* in the current working
directory.

The `dataImput` is as follows:

| R.Condition | R.Replicate | NUD4B_HUMAN (+1) | A0A7P0T808_HUMAN (+1) | A0A8I5KU53_HUMAN (+1) | ZN840_HUMAN | CC85C_HUMAN | C9JEV0_HUMAN (+1) | C9JNU9_HUMAN | ALBU_BOVIN | CYC_BOVIN | TRFE_BOVIN | F8W0H2_HUMAN | H0Y7V7_HUMAN (+1) | H0YD14_HUMAN | H3BUF6_HUMAN | H7C1W4_HUMAN (+1) | H7C3M7_HUMAN | TLR3_HUMAN | LRIG2_HUMAN | RAB3D_HUMAN | ADH1_YEAST | LYSC_CHICK | BGAL_ECOLI | CYTA_HUMAN | KPCB_HUMAN | LIPL_HUMAN | CO6_HUMAN | BGAL_HUMAN | SYTC_HUMAN | CASPE_HUMAN | DCAF6_HUMAN | DALD3_HUMAN | HGNAT_HUMAN | RFFL_HUMAN | RN185_HUMAN | ZN462_HUMAN | ALKB7_HUMAN | POLK_HUMAN | ACAD8_HUMAN |
|:---|:---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 100pmol | 1 | 10.37045 | 11.406514 | 10.956950 | 8.392426 | 8.710518 | 7.829510 | 8.023133 | 16.75777 | 12.96499 | 13.97388 | 9.136271 | 10.231965 | 10.048461 | 8.179306 | 8.279169 | 9.874410 | 7.001503 | 8.832972 | 9.978488 | 15.16303 | 13.62766 | 14.44005 | 8.964155 | 9.574185 | 8.517979 | 6.764393 | 12.07953 | 14.76033 | 6.004586 | 7.670711 | 10.129049 | 10.681337 | 7.242036 | 9.727210 | 9.376507 | 7.109682 | 7.393910 | 7.530379 |
| 100pmol | 2 | 11.40651 | 12.964987 | 9.727210 | 8.517979 | 8.832972 | 7.242036 | 8.023133 | 16.75777 | 13.62766 | 14.20112 | 8.964155 | 10.048461 | 10.231965 | 7.829510 | 7.670711 | 9.574185 | 7.393910 | 8.610420 | 10.129049 | 15.16303 | 13.97388 | 14.44005 | 9.136271 | 9.978488 | 8.279169 | 6.420716 | 12.07953 | 14.76033 | 7.109682 | 8.179306 | 9.874410 | 10.956950 | 7.001503 | 10.370449 | 8.392426 | 6.004586 | 9.376507 | 7.530379 |
| 100pmol | 3 | 10.32522 | 11.893804 | 10.851852 | 7.868171 | 8.887142 | 6.429596 | 8.646475 | 16.75777 | 12.81909 | 13.94448 | 9.027184 | 9.940284 | 9.504539 | 8.074082 | 7.698334 | 10.467264 | 7.413486 | 8.433160 | 10.022816 | 15.15272 | 13.55168 | 14.42169 | 8.758911 | 9.812352 | 8.213284 | 6.777937 | 11.29130 | 14.74334 | 6.004586 | 8.311138 | 9.649565 | 10.097660 | 7.009435 | 10.195272 | 8.550204 | 7.121143 | 7.262869 | 7.555404 |
| 100pmol | 4 | 10.51096 | 12.079525 | 10.956950 | 8.279169 | 8.964155 | 6.004586 | 8.023133 | 16.75777 | 12.96499 | 13.97388 | 9.136271 | 10.048461 | 9.978488 | 7.829510 | 7.670711 | 9.376507 | 7.829510 | 8.517979 | 10.231965 | 15.16303 | 13.62766 | 14.20112 | 8.710518 | 10.129049 | 8.179306 | 7.109682 | 11.40651 | 14.76033 | 6.420716 | 7.530379 | 8.832972 | 10.681337 | 6.764393 | 9.874410 | 8.392426 | 7.001503 | 7.242036 | 7.393910 |
| 200pmol | 1 | 10.27762 | 12.256403 | 10.413259 | 8.356482 | 7.375266 | 7.098768 | 8.149770 | 16.75777 | 13.10393 | 14.00189 | 9.255807 | 10.077232 | 9.798890 | 8.142561 | 7.974610 | 10.164570 | 7.644405 | 8.253204 | 9.927121 | 15.17286 | 14.22236 | 14.77650 | 8.577167 | 10.010298 | 8.782531 | 7.222195 | 11.51625 | 14.45755 | 6.412260 | 7.506546 | 9.641587 | 10.556023 | 6.751494 | 8.669939 | 9.040857 | 7.792691 | 6.993948 | 8.905805 |
| 200pmol | 2 | 10.53171 | 11.078642 | 10.729201 | 8.356482 | 8.732804 | 7.026553 | 8.267212 | 16.75777 | 12.49496 | 13.38772 | 9.012072 | 10.120238 | 9.798890 | 8.149770 | 7.964140 | 9.954832 | 7.608925 | 8.620541 | 10.229206 | 15.13045 | 13.88102 | 14.70670 | 8.866513 | 10.377729 | 8.386314 | 7.145874 | 11.59517 | 14.38206 | 6.004586 | 7.766206 | 9.827232 | 9.232358 | 6.448756 | 9.504539 | 8.520402 | 6.807164 | 7.455730 | 7.307825 |
| 200pmol | 3 | 11.05704 | 8.142561 | 12.256403 | 8.356482 | 8.905805 | 6.412260 | 8.669939 | 16.75777 | 14.00189 | 13.70002 | 9.255807 | 10.413259 | 10.164570 | 7.792691 | 7.506546 | 10.010298 | 7.375266 | 8.476493 | 10.277619 | 15.17286 | 14.22236 | 14.77650 | 8.577167 | 9.927121 | 8.253204 | 6.993948 | 13.10393 | 14.45755 | 6.004586 | 7.098768 | 10.077232 | 11.516245 | 6.751494 | 9.798890 | 9.040857 | 7.974610 | 7.222195 | 7.644405 |
| 200pmol | 4 | 10.72920 | 8.520402 | 11.595175 | 8.732804 | 7.964140 | 6.448756 | 8.149770 | 16.75777 | 13.38772 | 13.88102 | 9.504539 | 9.954832 | 10.229206 | 8.267212 | 6.807164 | 10.036651 | 7.455730 | 8.253204 | 10.531713 | 15.13045 | 14.13067 | 14.70670 | 9.232358 | 10.377729 | 8.386314 | 7.026553 | 12.49496 | 14.38206 | 6.004586 | 7.608925 | 10.120238 | 11.078642 | 7.145874 | 9.658384 | 8.866513 | 7.766206 | 7.307825 | 8.620541 |
| 50pmol | 1 | 10.72920 | 9.232358 | 7.766206 | 8.267212 | 8.732804 | 9.658384 | 7.964140 | 16.75777 | 12.49496 | 13.88102 | 9.504539 | 10.120238 | 10.377729 | 8.520402 | 7.608925 | 9.827232 | 7.455730 | 8.620541 | 10.531713 | 14.70670 | 13.38772 | 14.38206 | 11.078642 | 10.229206 | 8.386314 | 7.026553 | 11.59517 | 15.13045 | 9.954832 | 7.307825 | 8.298269 | 9.012072 | 6.807164 | 8.866513 | 6.448756 | 8.149770 | 6.004586 | 7.145874 |
| 50pmol | 2 | 10.96831 | 6.004586 | 10.662903 | 8.659793 | 8.785723 | 8.190682 | 8.555305 | 16.75777 | 12.30540 | 13.84672 | 9.753718 | 9.581714 | 10.189464 | 8.429646 | 7.035806 | 10.008606 | 7.159242 | 9.099265 | 10.482590 | 14.36063 | 13.25790 | 14.10465 | 10.086066 | 10.189464 | 8.926299 | 7.637117 | 11.47571 | 15.11842 | 8.017625 | 7.480137 | 8.298269 | 10.329078 | 6.459113 | 9.911682 | 9.362666 | 7.332126 | 6.004586 | 6.822962 |
| 50pmol | 3 | 11.59517 | 6.004586 | 10.729201 | 6.448756 | 8.732804 | 8.149770 | 8.386314 | 16.75777 | 13.38772 | 14.13067 | 9.658384 | 9.362666 | 10.377729 | 8.620541 | 7.026553 | 9.954832 | 7.035806 | 8.429646 | 10.531713 | 14.70670 | 13.88102 | 14.38206 | 10.036651 | 10.229206 | 9.012072 | 7.455730 | 12.49496 | 15.13045 | 7.964140 | 7.766206 | 8.520402 | 10.120238 | 7.145874 | 9.504539 | 8.267212 | 8.866513 | 7.307825 | 6.807164 |
| 50pmol | 4 | 10.96831 | 10.008606 | 10.662903 | 8.298269 | 8.190682 | 7.806291 | 8.659793 | 16.75777 | 12.30540 | 13.84672 | 9.504539 | 9.362666 | 10.482590 | 8.555305 | 6.004586 | 9.753718 | 7.035806 | 8.429646 | 10.329078 | 14.68689 | 13.25790 | 14.10465 | 9.911682 | 10.189464 | 8.386314 | 7.026553 | 11.47571 | 15.11842 | 7.637117 | 8.017625 | 9.581714 | 10.086066 | 6.459113 | 9.099265 | 8.926299 | 7.480137 | 7.159242 | 6.822962 |

## Details

The two primary MS/MS acquisition types implemented in large scale
MS-based proteomics have unique advantages and disadvantages.
Traditional Data-Dependent Acquisition (DDA) methods favor specificity
in MS/MS sampling over comprehensive proteome coverage. Small peptide
isolation windows (\<3 m/z) result in MS/MS spectra that contain
fragmentation data from ideally only one peptide. This specificity
promotes clear peptide identifications but comes at the expense of added
scan time. In DDA experiments, the number of peptides that can be
selected for MS/MS is limited by instrument scan speeds and is therefore
prioritized by highest peptide abundance. Low abundance peptides are
sampled less frequently for MS/MS and this can result in variable
peptide coverage and many missing protein data across large sample
datasets.

Data-Independent Acquisition (DIA) methods promote comprehensive peptide
coverage over specificity by sampling many peptides for MS/MS
simultaneously. Sequential and large mass isolation windows (4-50 m/z)
are used to isolate large numbers of peptides at once for concurrent
MS/MS. This produces complicated fragmentation spectra, but these
spectra contain data on every observable peptide. A major disadvantage
with this type of acquisition is that DIA MS/MS spectra are incredibly
complex and difficult to deconvolve. Powerful and relatively new
software programs like Spectronaut are capable of successfully parsing
out which fragment ions came from each co-fragmented peptide using
custom libraries, machine learning algorithms, and precisely determined
retention times or measured ion mobility data. Because all observable
ions are sampled for MS/MS, DIA reduces missingness substantially
compared to DDA, though not entirely.

Various imputation methods have been developed to address the
missing-value issue and assign a reasonable guess of quantitative value
to proteins with missing values. So far, this package provides 10
imputation methods for use:

1.  [`impute.min_local()`](https://uconn-scs.github.io/msDiaLogue/reference/impute.min_local.md):
    Replaces missing values with the lowest measured value for that
    protein in that condition.

2.  [`impute.min_global()`](https://uconn-scs.github.io/msDiaLogue/reference/impute.min_global.md):
    Replaces missing values with the lowest measured value from any
    protein found within the entire dataset.

3.  [`impute.knn()`](https://uconn-scs.github.io/msDiaLogue/reference/impute.knn.md):
    Replaces missing values using the k-nearest neighbors algorithm
    (Troyanskaya et al. 2001).

4.  [`impute.knn_seq()`](https://uconn-scs.github.io/msDiaLogue/reference/impute.knn_seq.md):
    Replaces missing values using the sequential k-nearest neighbors
    algorithm (Kim et al. 2004).

5.  [`impute.knn_trunc()`](https://uconn-scs.github.io/msDiaLogue/reference/impute.knn_trunc.md):
    Replaces missing values using the truncated k-nearest neighbors
    algorithm (Shah et al. 2017).

6.  [`impute.nuc_norm()`](https://uconn-scs.github.io/msDiaLogue/reference/impute.nuc_norm.md):
    Replaces missing values using the nuclear-norm regularization
    (Hastie et al. 2015).

7.  [`impute.mice_cart()`](https://uconn-scs.github.io/msDiaLogue/reference/impute.mice_cart.md):
    Replaces missing values using the classification and regression
    trees (Breiman et al. 1984; Doove et al. 2014; van Buuren 2018).

8.  [`impute.mice_norm()`](https://uconn-scs.github.io/msDiaLogue/reference/impute.mice_norm.md):
    Replaces missing values using the Bayesian linear regression (Rubin
    1987; Schafer 1997; van Buuren and Groothuis-Oudshoorn 2011).

9.  [`impute.pca_bayes()`](https://uconn-scs.github.io/msDiaLogue/reference/impute.pca_bayes.md):
    Replaces missing values using the Bayesian principal components
    analysis (Oba et al. 2003).

10. [`impute.pca_prob()`](https://uconn-scs.github.io/msDiaLogue/reference/impute.pca_prob.md):
    Replaces missing values using the probabilistic principal components
    analysis (Stacklies et al. 2007).

Additional methods will be added later.

## Reference

[←
Previous](https://uconn-scs.github.io/msDiaLogue/articles/normalization.md)

[Next
→](https://uconn-scs.github.io/msDiaLogue/articles/summarization.md)

Breiman, L., J. Friedman, R. A. Olshen, and C. J. Stone. 1984.
*Classification and Regression Trees*. Routledge.

Doove, Lisa L., Stef van Buuren, and Elise Dusseldorp. 2014. “Recursive
Partitioning for Missing Data Imputation in the Presence of Interaction
Effects.” *Computational Statistics & Data Analysis* 72: 92–104.
<https://doi.org/10.1016/j.csda.2013.10.025>.

Hastie, Trevor, Rahul Mazumder, Jason D. Lee, and Reza Zadeh. 2015.
“Matrix Completion and Low-Rank SVD via Fast Alternating Least Squares.”
*Journal of Machine Learning Research* 16 (104): 3367—3402.
[http://jmlr.org/papers/v16/hastie15a.html](http://jmlr.org/papers/v16/hastie15a.md).

Kim, Ki-Yeol, Byoung-Jin Kim, and Gwan-Su Yi. 2004. “Reuse of Imputed
Data in Microarray Analysis Increases Imputation Efficiency.” *BMC
Bioinformatics* 5: 160. <https://doi.org/10.1186/1471-2105-5-160>.

Oba, Shigeyuki, Masa-aki Sato, Ichiro Takemasa, Morito Monden, Ken-ichi
Matsubara, and Shin Ishii. 2003. “A Bayesian Missing Value Estimation
Method for Gene Expression Profile Data.” *Bioinformatics* 19 (16):
2088–96. <https://doi.org/10.1093/bioinformatics/btg287>.

Rubin, Donald B. 1987. *Multiple Imputation for Nonresponse in Surveys*.
John Wiley & Sons.

Schafer, Joseph L. 1997. *Analysis of Incomplete Multivariate Data*.
Chapman & Hall/CRC.

Shah, Jasmit S., Shesh N. Rai, Andrew P. DeFilippis, Bradford G. Hill,
Aruni Bhatnagar, and Guy N. Brock. 2017. “Distribution Based Nearest
Neighbor Imputation for Truncated High Dimensional Data with
Applications to Pre-Clinical and Clinical Metabolomics Studies.” *BMC
Bioinformatics* 18: 114. <https://doi.org/10.1186/s12859-017-1547-6>.

Stacklies, Wolfram, Henning Redestig, Matthias Scholz, Dirk Walther, and
Joachim Selbig. 2007. “pcaMethods–a Bioconductor Package Providing PCA
Methods for Incomplete Data.” *Bioinformatics* 23 (9): 1164–67.
<https://doi.org/10.1093/bioinformatics/btm069>.

Troyanskaya, Olga, Michael Cantor, Gavin Sherlock, et al. 2001. “Missing
Value Estimation Methods for DNA Microarrays.” *Bioinformatics* 17 (6):
520–25. <https://doi.org/10.1093/bioinformatics/17.6.520>.

van Buuren, Stef. 2018. *Flexible Imputation of Missing Data*. Chapman &
Hall/CRC.

van Buuren, Stef, and Karin Groothuis-Oudshoorn. 2011. “Mice:
Multivariate Imputation by Chained Equations in R.” *Journal of
Statistical Software* 45 (3): 1–67.
<https://doi.org/10.18637/jss.v045.i03>.
