# TL - 160724

# This script parses the outputs of the tar.gz files to generate summary tables

mkdir ./tmp_dir/ 
outputsummaryfile=$(echo "Summary_DILS3_simulations_160724.txt")
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
	# if Tevent exists (Tam/ Tsc)
	grep '^Tam	\|^Tsc	' tmp_param > tmp_param_tevent
	if [ ! -s tmp_param_tevent ]; then
		NN_Tevent=$(echo "--")
		RF_Tevent=$(echo "--")
	else
		NN_Tevent=$(head -1 tmp_param_tevent | awk '{print $3"["$2"-"$4"]"}')
		RF_Tevent=$(tail -1 tmp_param_tevent | awk '{print $3"["$2"-"$4"]"}')
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
	fi	
	current_parameters=$(echo "$NN_popsizesubsp1	$NN_popsizesubsp2	$NN_popsizeanc	$NN_Tsplit	$NN_Tevent	$NN_founderssubsp1	$NN_founderssubsp2	$NN_demochangessubsp1	$NN_demochangessubsp2	$RF_popsizesubsp1	$RF_popsizesubsp2	$RF_popsizeanc	$RF_Tsplit	$RF_Tevent	$RF_founderssubsp1	$RF_founderssubsp2	$RF_demochangessubsp1	$RF_demochangessubsp2")
	echo "$current_info	$current_models	$current_parameters" >> $outputsummaryfile
done
rm -r ./tmp_dir/
