# TL - 160724

# This script parses the outputs of the tar.gz files to generate summary tables

mkdir ./tmp_dir/ 
outputsummaryfile=$(echo "Summary_DILS3_simulations_all5subsp_withOuessantColonsay_rescaledunits1p5Ne_270824.txt")
rm $outputsummaryfile #, if exists

for filename1 in *.tar.gz; do
	# parse general information about the comparisons
	filename_fields=$(echo $filename1 | sed 's/resDILS\_//g' | sed 's/\.tar\.gz//g')
	echo "$filename_fields"
	subspecies1=$(echo "$filename_fields" | awk -F "_" '{print $1}')
	subspecies2=$(echo "$filename_fields" | awk -F "_" '{print $2}')
	outgroupspecies=$(echo "$filename_fields" | awk -F "_" '{print $5}' | sed 's/outgroup//g')
	modelNe=$(echo "$filename_fields" | awk -F "_" '{print $3}' | sed 's/Ne//g')
	useofSFS=$(echo "$filename_fields" | awk -F "_" '{print $4}' | sed 's/SFS//g')
	echo "Currently working on $filename1"
	current_info=$(echo "$subspecies1	$subspecies2	$outgroupspecies	$modelNe	$useofSFS")
	
	# now uncompress the file and works on the files
	currentfileinput=$(echo "report_$subspecies1"_"$subspecies2"".txt")
	tar -xf $filename1 -C ./tmp_dir/
	less ./tmp_dir/resDILS_$filename_fields/modelComp/$currentfileinput > tmp_model
	less ./tmp_dir/resDILS_$filename_fields/best_model_5/$currentfileinput > tmp_param
	
	# parse information from model choice
	# migration / isolation
	grep -A 8 "MODEL COMPARISON #1: migration versus isolation" tmp_model > tmp_model1
	model1=$(grep "#best model" tmp_model1 | sed 's/#best model: //g')
	postprobamodel1=$(grep "#proba best model" tmp_model1 | sed 's/#proba best model: //g' | cut -c1-7) 
	
	grep -A 8 "MODEL COMPARISON #2:" tmp_model > tmp_model2
	model2=$(grep "#best model" tmp_model2 | sed 's/#best model: //g')
	postprobamodel2=$(grep "#proba best model" tmp_model2 | sed 's/#proba best model: //g' | cut -c1-7) 
	
	grep -A 8 "MODEL COMPARISON #3: Mhomo versus Mhetero" tmp_model > tmp_model3
	#head tmp_model3
	if [ ! -s tmp_model3 ]; then
		model3=$(echo "--")
		postprobamodel3=$(echo "--")
	else
		model3=$(grep "#best model" tmp_model3 | sed 's/#best model: //g')
		postprobamodel3=$(grep "#proba best model" tmp_model3 | sed 's/#proba best model: //g' | cut -c1-7)
		
	fi 
	
	grep -A 8 ": Nhomo versus Nhetero" tmp_model > tmp_model4
	model4=$(grep "#best model" tmp_model4 | sed 's/#best model: //g')
	postprobamodel4=$(grep "#proba best model" tmp_model4 | sed 's/#proba best model: //g' | cut -c1-7)
			
	rm tmp_model*
	# information to keep from the analysis of the tmp_model
	current_models=$(echo "$model1	$postprobamodel1	$model2	$postprobamodel2	$model3	$postprobamodel3	$model4	$postprobamodel4")
	
	# parse information from parameters
	NN_popsizesubsp1=$(grep "^N1	" tmp_param | head -1 | awk '{print $3"["$2"-"$4"]"}')
	RF_popsizesubsp1=$(grep "^N1	" tmp_param | tail -1 | awk '{print $3"["$2"-"$4"]"}')
	NN_popsizesubsp2=$(grep "^N2	" tmp_param | head -1 | awk '{print $3"["$2"-"$4"]"}')
	RF_popsizesubsp2=$(grep "^N2	" tmp_param | tail -1 | awk '{print $3"["$2"-"$4"]"}')
	NN_popsizeanc=$(grep "^Na	" tmp_param | head -1 | awk '{print $3"["$2"-"$4"]"}')
	RF_popsizeanc=$(grep "^Na	" tmp_param | tail -1 | awk '{print $3"["$2"-"$4"]"}')
	NN_Tsplit=$(grep "^Tsplit	" tmp_param | head -1 | awk '{print $3"["$2"-"$4"]"}')
	RF_Tsplit=$(grep "^Tsplit	" tmp_param | tail -1 | awk '{print $3"["$2"-"$4"]"}')
	# rescale time to 1.5 Ne units
	NN_popsizesubsp1_median=$(echo "$NN_popsizesubsp1" | awk -F "[" '{print $1}' | bc)
	NN_popsizesubsp1_median_rescaled=$(echo "$NN_popsizesubsp1_median * 1.3333333333333333" | bc)
	NN_popsizesubsp1_lower=$(echo "$NN_popsizesubsp1" | awk -F "[" '{print $2}'  | awk -F "-" '{print $1}' | bc)
	NN_popsizesubsp1_lower_rescaled=$(echo "$NN_popsizesubsp1_lower * 1.3333333333333333" | bc)
	NN_popsizesubsp1_upper=$(echo "$NN_popsizesubsp1" | awk -F "[" '{print $2}' | awk -F "-" '{print $2}' | sed 's/\]//g' | bc)
	NN_popsizesubsp1_upper_rescaled=$(echo "$NN_popsizesubsp1_upper * 1.3333333333333333" | bc)
	NN_popsizesubsp1_rescaled=$(echo "$NN_popsizesubsp1_median_rescaled"" [""$NN_popsizesubsp1_lower_rescaled""-""$NN_popsizesubsp1_upper_rescaled""]")
	
	RF_popsizesubsp1_median=$(echo "$RF_popsizesubsp1" | awk -F "[" '{print $1}' | bc)
	RF_popsizesubsp1_median_rescaled=$(echo "$RF_popsizesubsp1_median * 1.3333333333333333" | bc)
	RF_popsizesubsp1_lower=$(echo "$RF_popsizesubsp1" | awk -F "[" '{print $2}'  | awk -F "-" '{print $1}' | bc)
	RF_popsizesubsp1_lower_rescaled=$(echo "$RF_popsizesubsp1_lower * 1.3333333333333333" | bc)
	RF_popsizesubsp1_upper=$(echo "$RF_popsizesubsp1" | awk -F "[" '{print $2}' | awk -F "-" '{print $2}' | sed 's/\]//g' | bc)
	RF_popsizesubsp1_upper_rescaled=$(echo "$RF_popsizesubsp1_upper * 1.3333333333333333" | bc)
	RF_popsizesubsp1_rescaled=$(echo "$RF_popsizesubsp1_median_rescaled"" [""$RF_popsizesubsp1_lower_rescaled""-""$RF_popsizesubsp1_upper_rescaled""]")
	
	NN_popsizesubsp2_median=$(echo "$NN_popsizesubsp2" | awk -F "[" '{print $1}' | bc)
	NN_popsizesubsp2_median_rescaled=$(echo "$NN_popsizesubsp2_median * 1.3333333333333333" | bc)
	NN_popsizesubsp2_lower=$(echo "$NN_popsizesubsp2" | awk -F "[" '{print $2}'  | awk -F "-" '{print $1}' | bc)
	NN_popsizesubsp2_lower_rescaled=$(echo "$NN_popsizesubsp2_lower * 1.3333333333333333" | bc)
	NN_popsizesubsp2_upper=$(echo "$NN_popsizesubsp2" | awk -F "[" '{print $2}' | awk -F "-" '{print $2}' | sed 's/\]//g' | bc)
	NN_popsizesubsp2_upper_rescaled=$(echo "$NN_popsizesubsp2_upper * 1.3333333333333333" | bc)
	NN_popsizesubsp2_rescaled=$(echo "$NN_popsizesubsp2_median_rescaled"" [""$NN_popsizesubsp2_lower_rescaled""-""$NN_popsizesubsp2_upper_rescaled""]")
	
	RF_popsizesubsp2_median=$(echo "$RF_popsizesubsp2" | awk -F "[" '{print $1}' | bc)
	RF_popsizesubsp2_median_rescaled=$(echo "$RF_popsizesubsp2_median * 1.3333333333333333" | bc)
	RF_popsizesubsp2_lower=$(echo "$RF_popsizesubsp2" | awk -F "[" '{print $2}'  | awk -F "-" '{print $1}' | bc)
	RF_popsizesubsp2_lower_rescaled=$(echo "$RF_popsizesubsp2_lower * 1.3333333333333333" | bc)
	RF_popsizesubsp2_upper=$(echo "$RF_popsizesubsp2" | awk -F "[" '{print $2}' | awk -F "-" '{print $2}' | sed 's/\]//g' | bc)
	RF_popsizesubsp2_upper_rescaled=$(echo "$RF_popsizesubsp2_upper * 1.3333333333333333" | bc)
	RF_popsizesubsp2_rescaled=$(echo "$RF_popsizesubsp2_median_rescaled"" [""$RF_popsizesubsp2_lower_rescaled""-""$RF_popsizesubsp2_upper_rescaled""]")
	
	NN_popsizeanc_median=$(echo "$NN_popsizeanc" | awk -F "[" '{print $1}' | bc)
	NN_popsizeanc_median_rescaled=$(echo "$NN_popsizeanc_median * 1.3333333333333333" | bc)
	NN_popsizeanc_lower=$(echo "$NN_popsizeanc" | awk -F "[" '{print $2}'  | awk -F "-" '{print $1}' | bc)
	NN_popsizeanc_lower_rescaled=$(echo "$NN_popsizeanc_lower * 1.3333333333333333" | bc)
	NN_popsizeanc_upper=$(echo "$NN_popsizeanc" | awk -F "[" '{print $2}' | awk -F "-" '{print $2}' | sed 's/\]//g' | bc)
	NN_popsizeanc_upper_rescaled=$(echo "$NN_popsizeanc_upper * 1.3333333333333333" | bc)
	NN_popsizeanc_rescaled=$(echo "$NN_popsizeanc_median_rescaled"" [""$NN_popsizeanc_lower_rescaled""-""$NN_popsizeanc_upper_rescaled""]")
	
	RF_popsizeanc_median=$(echo "$RF_popsizeanc" | awk -F "[" '{print $1}' | bc)
	RF_popsizeanc_median_rescaled=$(echo "$RF_popsizeanc_median * 1.3333333333333333" | bc)
	RF_popsizeanc_lower=$(echo "$RF_popsizeanc" | awk -F "[" '{print $2}'  | awk -F "-" '{print $1}' | bc)
	RF_popsizeanc_lower_rescaled=$(echo "$RF_popsizeanc_lower * 1.3333333333333333" | bc)
	RF_popsizeanc_upper=$(echo "$RF_popsizeanc" | awk -F "[" '{print $2}' | awk -F "-" '{print $2}' | sed 's/\]//g' | bc)
	RF_popsizeanc_upper_rescaled=$(echo "$RF_popsizeanc_upper * 1.3333333333333333" | bc)
	RF_popsizeanc_rescaled=$(echo "$RF_popsizeanc_median_rescaled"" [""$RF_popsizeanc_lower_rescaled""-""$RF_popsizeanc_upper_rescaled""]")
	
	NN_Tsplit_median=$(echo "$NN_Tsplit" | awk -F "[" '{print $1}' | bc)
	NN_Tsplit_median_rescaled=$(echo "$NN_Tsplit_median * 1.3333333333333333" | bc)
	NN_Tsplit_lower=$(echo "$NN_Tsplit" | awk -F "[" '{print $2}'  | awk -F "-" '{print $1}' | bc)
	NN_Tsplit_lower_rescaled=$(echo "$NN_Tsplit_lower * 1.3333333333333333" | bc)
	NN_Tsplit_upper=$(echo "$NN_Tsplit" | awk -F "[" '{print $2}' | awk -F "-" '{print $2}' | sed 's/\]//g' | bc)
	NN_Tsplit_upper_rescaled=$(echo "$NN_Tsplit_upper * 1.3333333333333333" | bc)
	NN_Tsplit_rescaled=$(echo "$NN_Tsplit_median_rescaled"" [""$NN_Tsplit_lower_rescaled""-""$NN_Tsplit_upper_rescaled""]")

	RF_Tsplit_median=$(echo "$RF_Tsplit" | awk -F "[" '{print $1}' | bc)
	RF_Tsplit_median_rescaled=$(echo "$RF_Tsplit_median * 1.3333333333333333" | bc)
	RF_Tsplit_lower=$(echo "$RF_Tsplit" | awk -F "[" '{print $2}'  | awk -F "-" '{print $1}' | bc)
	RF_Tsplit_lower_rescaled=$(echo "$RF_Tsplit_lower * 1.3333333333333333" | bc)
	RF_Tsplit_upper=$(echo "$RF_Tsplit" | awk -F "[" '{print $2}' | awk -F "-" '{print $2}' | sed 's/\]//g' | bc)
	RF_Tsplit_upper_rescaled=$(echo "$RF_Tsplit_upper * 1.3333333333333333" | bc)
	RF_Tsplit_rescaled=$(echo "$RF_Tsplit_median_rescaled"" [""$RF_Tsplit_lower_rescaled""-""$RF_Tsplit_upper_rescaled""]")
	
	# if Tevent exists (Tam/ Tsc)
	grep '^Tam	\|^Tsc	' tmp_param > tmp_param_tevent
	if [ ! -s tmp_param_tevent ]; then
		NN_Tevent=$(echo "--")
		RF_Tevent=$(echo "--")
	else
		NN_Tevent=$(head -1 tmp_param_tevent | awk '{print $3"["$2"-"$4"]"}')
		RF_Tevent=$(tail -1 tmp_param_tevent | awk '{print $3"["$2"-"$4"]"}')
		# rescaled to 1.5 Ne
		NN_Tevent_median=$(echo "$NN_Tevent" | awk -F "[" '{print $1}' | bc)
		NN_Tevent_median_rescaled=$(echo "$NN_Tevent_median * 1.3333333333333333" | bc)
		NN_Tevent_lower=$(echo "$NN_Tevent" | awk -F "[" '{print $2}'  | awk -F "-" '{print $1}' | bc)
		NN_Tevent_lower_rescaled=$(echo "$NN_Tevent_lower * 1.3333333333333333" | bc)
		NN_Tevent_upper=$(echo "$NN_Tevent" | awk -F "[" '{print $2}' | awk -F "-" '{print $2}' | sed 's/\]//g' | bc)
		NN_Tevent_upper_rescaled=$(echo "$NN_Tevent_upper * 1.3333333333333333" | bc)
		NN_Tevent_rescaled=$(echo "$NN_Tevent_median_rescaled"" [""$NN_Tevent_lower_rescaled""-""$NN_Tevent_upper_rescaled""]")
		
		RF_Tevent_median=$(echo "$RF_Tevent" | awk -F "[" '{print $1}' | bc)
		RF_Tevent_median_rescaled=$(echo "$RF_Tevent_median * 1.3333333333333333" | bc)
		RF_Tevent_lower=$(echo "$RF_Tevent" | awk -F "[" '{print $2}'  | awk -F "-" '{print $1}' | bc)
		RF_Tevent_lower_rescaled=$(echo "$RF_Tevent_lower * 1.3333333333333333" | bc)
		RF_Tevent_upper=$(echo "$RF_Tevent" | awk -F "[" '{print $2}' | awk -F "-" '{print $2}' | sed 's/\]//g' | bc)
		RF_Tevent_upper_rescaled=$(echo "$RF_Tevent_upper * 1.3333333333333333" | bc)
		RF_Tevent_rescaled=$(echo "$RF_Tevent_median_rescaled"" [""$RF_Tevent_lower_rescaled""-""$RF_Tevent_upper_rescaled""]")
	fi 
	# if models with temporal changes in Ne
	grep "^founders" tmp_param > tmp_param_founders
	if [ ! -s tmp_param_founders ]; then
		NN_founderssubsp1=$(echo "--")
		RF_founderssubsp1=$(echo "--")
		NN_founderssubsp2=$(echo "--")
		RF_founderssubsp2=$(echo "--")
	else
		NN_founderssubsp1=$(grep "^founders1	" tmp_param_founders | head -1 | awk '{print $3"["$2"-"$4"]"}')
		RF_founderssubsp1=$(grep "^founders1	" tmp_param_founders | tail -1 | awk '{print $3"["$2"-"$4"]"}')
		NN_founderssubsp2=$(grep "^founders2	" tmp_param_founders | head -1 | awk '{print $3"["$2"-"$4"]"}')
		RF_founderssubsp2=$(grep "^founders2	" tmp_param_founders | tail -1 | awk '{print $3"["$2"-"$4"]"}')
	fi
	grep "^Tdem" tmp_param > tmp_param_demochanges
	if [ ! -s tmp_param_demochanges ]; then
		NN_demochangessubsp1=$(echo "--")
		RF_demochangessubsp1=$(echo "--")
		NN_demochangessubsp2=$(echo "--")
		RF_demochangessubsp2=$(echo "--")
	else
		NN_demochangessubsp1=$(grep "^Tdem1	" tmp_param_demochanges | head -1 | awk '{print $3"["$2"-"$4"]"}')
		RF_demochangessubsp1=$(grep "^Tdem1	" tmp_param_demochanges | tail -1 | awk '{print $3"["$2"-"$4"]"}')
		NN_demochangessubsp2=$(grep "^Tdem2	" tmp_param_demochanges | head -1 | awk '{print $3"["$2"-"$4"]"}')
		RF_demochangessubsp2=$(grep "^Tdem2	" tmp_param_demochanges | tail -1 | awk '{print $3"["$2"-"$4"]"}')
		# rescaled to 1.5 Ne	
		NN_demochangessubsp1_median=$(echo "$NN_demochangessubsp1" | awk -F "[" '{print $1}' | bc)
		NN_demochangessubsp1_median_rescaled=$(echo "$NN_demochangessubsp1_median * 1.3333333333333333" | bc)
		NN_demochangessubsp1_lower=$(echo "$NN_demochangessubsp1" | awk -F "[" '{print $2}'  | awk -F "-" '{print $1}' | bc)
		NN_demochangessubsp1_lower_rescaled=$(echo "$NN_demochangessubsp1_lower * 1.3333333333333333" | bc)
		NN_demochangessubsp1_upper=$(echo "$NN_demochangessubsp1" | awk -F "[" '{print $2}' | awk -F "-" '{print $2}' | sed 's/\]//g' | bc)
		NN_demochangessubsp1_upper_rescaled=$(echo "$NN_demochangessubsp1_upper * 1.3333333333333333" | bc)
		NN_demochangessubsp1_rescaled=$(echo "$NN_demochangessubsp1_median_rescaled"" [""$NN_demochangessubsp1_lower_rescaled""-""$NN_demochangessubsp1_upper_rescaled""]")
		
		RF_demochangessubsp1_median=$(echo "$RF_demochangessubsp1" | awk -F "[" '{print $1}' | bc)
		RF_demochangessubsp1_median_rescaled=$(echo "$RF_demochangessubsp1_median * 1.3333333333333333" | bc)
		RF_demochangessubsp1_lower=$(echo "$RF_demochangessubsp1" | awk -F "[" '{print $2}'  | awk -F "-" '{print $1}' | bc)
		RF_demochangessubsp1_lower_rescaled=$(echo "$RF_demochangessubsp1_lower * 1.3333333333333333" | bc)
		RF_demochangessubsp1_upper=$(echo "$RF_demochangessubsp1" | awk -F "[" '{print $2}' | awk -F "-" '{print $2}' | sed 's/\]//g' | bc)
		RF_demochangessubsp1_upper_rescaled=$(echo "$RF_demochangessubsp1_upper * 1.3333333333333333" | bc)
		RF_demochangessubsp1_rescaled=$(echo "$RF_demochangessubsp1_median_rescaled"" [""$RF_demochangessubsp1_lower_rescaled""-""$RF_demochangessubsp1_upper_rescaled""]")
		
		NN_demochangessubsp2_median=$(echo "$NN_demochangessubsp2" | awk -F "[" '{print $1}' | bc)
		NN_demochangessubsp2_median_rescaled=$(echo "$NN_demochangessubsp2_median * 1.3333333333333333" | bc)
		NN_demochangessubsp2_lower=$(echo "$NN_demochangessubsp2" | awk -F "[" '{print $2}'  | awk -F "-" '{print $1}' | bc)
		NN_demochangessubsp2_lower_rescaled=$(echo "$NN_demochangessubsp2_lower * 1.3333333333333333" | bc)
		NN_demochangessubsp2_upper=$(echo "$NN_demochangessubsp2" | awk -F "[" '{print $2}' | awk -F "-" '{print $2}' | sed 's/\]//g' | bc)
		NN_demochangessubsp2_upper_rescaled=$(echo "$NN_demochangessubsp2_upper * 1.3333333333333333" | bc)
		NN_demochangessubsp2_rescaled=$(echo "$NN_demochangessubsp2_median_rescaled"" [""$NN_demochangessubsp2_lower_rescaled""-""$NN_demochangessubsp2_upper_rescaled""]")
		
		RF_demochangessubsp2_median=$(echo "$RF_demochangessubsp2" | awk -F "[" '{print $1}' | bc)
		RF_demochangessubsp2_median_rescaled=$(echo "$RF_demochangessubsp2_median * 1.3333333333333333" | bc)
		RF_demochangessubsp2_lower=$(echo "$RF_demochangessubsp2" | awk -F "[" '{print $2}'  | awk -F "-" '{print $1}' | bc)
		RF_demochangessubsp2_lower_rescaled=$(echo "$RF_demochangessubsp2_lower * 1.3333333333333333" | bc)
		RF_demochangessubsp2_upper=$(echo "$RF_demochangessubsp2" | awk -F "[" '{print $2}' | awk -F "-" '{print $2}' | sed 's/\]//g' | bc)
		RF_demochangessubsp2_upper_rescaled=$(echo "$RF_demochangessubsp2_upper * 1.3333333333333333" | bc)
		RF_demochangessubsp2_rescaled=$(echo "$RF_demochangessubsp2_median_rescaled"" [""$RF_demochangessubsp2_lower_rescaled""-""$RF_demochangessubsp2_upper_rescaled""]")	
	fi	
	current_parameters=$(echo "$NN_popsizesubsp1_rescaled	$NN_popsizesubsp2_rescaled	$NN_popsizeanc_rescaled	$NN_Tsplit_rescaled	$NN_Tevent_rescaled	$NN_founderssubsp1	$NN_founderssubsp2	$NN_demochangessubsp1_rescaled	$NN_demochangessubsp2_rescaled	$RF_popsizesubsp1_rescaled	$RF_popsizesubsp2_rescaled	$RF_popsizeanc_rescaled	$RF_Tsplit_rescaled	$RF_Tevent_rescaled	$RF_founderssubsp1	$RF_founderssubsp2	$RF_demochangessubsp1_rescaled	$RF_demochangessubsp2_rescaled")
	echo "$current_info	$current_models	$current_parameters" >> $outputsummaryfile
	#echo "$NN_popsizesubsp1	$NN_popsizesubsp1_rescaled"
done
rm -r ./tmp_dir/ tmp*
