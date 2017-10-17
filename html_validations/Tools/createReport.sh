#!/bin/bash

#To launch this script, follow this structure :
#sh createReport.sh -a PU -b 7_4_3_p1_unsch -c 7_4_3 -d CMSSW_7_4_3_patch1-MCRUN2_74_V9_unsch-v1 -e CMSSW_7_4_3-MCRUN2_74_V9-v9 -f CMSSW_7_4_3_patch1-PU25ns_MCRUN2_74_V9_unsch-v1 -g CMSSW_7_4_3-PU25ns_MCRUN2_74_V9-v11 -h CMSSW_7_4_3_patch1-PU50ns_MCRUN2_74_V8_unsch-v1 -i CMSSW_7_4_3-PU50ns_MCRUN2_74_V8-v11

while getopts ":a:b:c:d:e:f:g:" option
do
        echo "getopts a trouvé l'option $option"
        case $option in
	    		a)
                        #echo "Exécution des commandes de l'option a"
                        echo "Option a -- Validation with PU or noPU : $OPTARG"
                        nofarg=$OPTARG
						#echo "Indice de la prochaine option à traiter : $OPTIND"
                        ;;						
				b)
                        #echo "Exécution des commandes de l'option b"
                        echo "Option b -- Name of CMSSW release : $OPTARG"
                        CMSSW_REL=$OPTARG
						#echo "Indice de la prochaine option à traiter : $OPTIND"
                        ;;						
            	c)
                        #echo "Exécution des commandes de l'option c"
                        echo "Option c -- Name of CMSSW reference : $OPTARG"
                        CMSSW_REF=$OPTARG
						#echo "Indice de la prochaine option à traiter : $OPTIND"
                        ;;						
				d)
                        #echo "Exécution des commandes de l'option d"
                        echo "Option d -- Release name for noPU : $OPTARG"
                        rel=$OPTARG
						#echo "Indice de la prochaine option à traiter : $OPTIND"
                        ;;
                e)
                        #echo "Exécution des commandes de l'option e"
                        echo "Option e -- Reference name for noPU : $OPTARG"
                        ref=$OPTARG
                        #echo "Indice de la prochaine option à traiter : $OPTIND"
                        ;;
                f)
                        #echo "Exécution des commandes de l'option f"
                        echo "Option f -- Release name for 25ns PU : $OPTARG"
                        rel25=$OPTARG
                        #echo "Indice de la prochaine option à traiter : $OPTIND"
                        ;;
                g)
                        #echo "Exécution des commandes de l'option g"
                        echo "Option g -- Reference name for 25ns PU : $OPTARG"
                        ref25=$OPTARG
                        #echo "Indice de la prochaine option à traiter : $OPTIND"
                        ;;
		esac
done
echo "Analyse des options terminée"



#Change base canevas if validation with or without PU, or with premix (meaning only PU25ns)
if [ "$nofarg" == "noPU" ]; then
		cp canevas_noPU.txt tmp.txt
elif [ "$nofarg" == "PU" ]; then
		cp canevas_PU.txt tmp.txt
elif [ "$nofarg" == "pmx" ]; then
		cp canevas_pmx.txt tmp.txt
fi

#Change name of the validation
sed "s/CMSSW_RELEASE/CMSSW_$CMSSW_REL/g" tmp.txt > tmp2.txt
sed "s/CMSSW_REFERENCE/CMSSW_$CMSSW_REF/g" tmp2.txt > tmp3.txt

#Create links now
beginning="https:\/\/cmsweb.cern.ch\/dqm\/relval\/start?runnr=1;dataset=\/"
middle="\/DQMIO;sampletype=offline_relval;filter=all;referencepos=overlay;referenceshow=all;referenceobj1=other%3A%3A\/"
directory="\/DQMIO%3A;referenceobj2=none;referenceobj3=none;referenceobj4=none;search=;striptype=object;stripruns=;stripaxis=run;stripomit=none;workspace=HLT;size=XL;root=HLT\/Layouts\/SMP\/"
end=";focus=;zoom=no;"
		

if [ "$nofarg" == "PU" ] || [ "$nofarg" == "noPU" ]; then

		#Change the name of the noPU part :
		sed "s/RELEASE_noPU/$rel/g" tmp3.txt > tmp4.txt
		sed "s/REFERENCE_noPU/$ref/g" tmp4.txt > tmp5.txt
		
		name="DoubleElectron"
		sample="RelValZEE_13\/"
		sed "s/DoubleElectronLink_noPU/$beginning$sample$rel$middle$sample$ref$directory$name$end/g" tmp5.txt > tmp6.txt
		
		name="SingleElectron"
		sample="RelValZEE_13\/"
		sed "s/SingleElectronLink_noPU/$beginning$sample$rel$middle$sample$ref$directory$name$end/g" tmp6.txt > tmp7.txt
		
		name="DoubleMuon"
		sample="RelValZMM_13\/"
		sed "s/DoubleMuonLink_noPU/$beginning$sample$rel$middle$sample$ref$directory$name$end/g" tmp7.txt > tmp8.txt
		
		name="SingleMuon"
		sample="RelValZMM_13\/"
		sed "s/SingleMuonLink_noPU/$beginning$sample$rel$middle$sample$ref$directory$name$end/g" tmp8.txt > tmp9.txt
		
		name="DoublePhoton"
		sample="RelValH125GGgluonfusion_13\/"
		sed "s/DoublePhotonLink_noPU/$beginning$sample$rel$middle$sample$ref$directory$name$end/g" tmp9.txt > tmp10.txt
		
		name="SinglePhoton"
		sample="RelValH125GGgluonfusion_13\/"
		sed "s/SinglePhotonLink_noPU/$beginning$sample$rel$middle$sample$ref$directory$name$end/g" tmp10.txt > tmp11.txt
		
		name="MuEG"
		sample="RelValTTbarLepton_13\/"
		sed "s/MuEGLink_noPU/$beginning$sample$rel$middle$sample$ref$directory$name$end/g" tmp11.txt > tmp12.txt
		
		name="SingleJet"
		sample="RelValQCD_FlatPt_15_3000HS_13\/"
		sed "s/SingleJetLink_noPU/$beginning$sample$rel$middle$sample$ref$directory$name$end/g" tmp12.txt > tmp13.txt
	
fi

if [ "$nofarg" == "pmx" ]; then
		mv tmp3.txt tmp13.txt
fi

if [ "$nofarg" == "PU" ] || [ "$nofarg" == "pmx" ]; then
		
		#Change the name of the PU part :
		sed "s/RELEASE_25/$rel25/g" tmp13.txt > tmp14.txt
		sed "s/REFERENCE_25/$ref25/g" tmp14.txt > tmp17.txt
	
		#Fill links for 25ns
		rel=$rel25
		ref=$ref25
		name="DoubleElectron"
		sample="RelValZEE_13\/"
		sed "s/DoubleElectronLink_25/$beginning$sample$rel$middle$sample$ref$directory$name$end/g" tmp17.txt > tmp18.txt
		
		name="SingleElectron"
		sample="RelValZEE_13\/"
		sed "s/SingleElectronLink_25/$beginning$sample$rel$middle$sample$ref$directory$name$end/g" tmp18.txt > tmp19.txt
		
		name="DoubleMuon"
		sample="RelValZMM_13\/"
		sed "s/DoubleMuonLink_25/$beginning$sample$rel$middle$sample$ref$directory$name$end/g" tmp19.txt > tmp20.txt
		
		name="SingleMuon"
		sample="RelValZMM_13\/"
		sed "s/SingleMuonLink_25/$beginning$sample$rel$middle$sample$ref$directory$name$end/g" tmp20.txt > tmp21.txt
		
		name="DoublePhoton"
		sample="RelValH125GGgluonfusion_13\/"
		sed "s/DoublePhotonLink_25/$beginning$sample$rel$middle$sample$ref$directory$name$end/g" tmp21.txt > tmp22.txt
		
		name="SinglePhoton"
		sample="RelValH125GGgluonfusion_13\/"
		sed "s/SinglePhotonLink_25/$beginning$sample$rel$middle$sample$ref$directory$name$end/g" tmp22.txt > tmp23.txt
		
		name="MuEG"
		sample="RelValTTbarLepton_13\/"
		sed "s/MuEGLink_25/$beginning$sample$rel$middle$sample$ref$directory$name$end/g" tmp23.txt > tmp24.txt
		
		name="SingleJet"
		sample="RelValQCD_FlatPt_15_3000HS_13\/"
		sed "s/SingleJetLink_25/$beginning$sample$rel$middle$sample$ref$directory$name$end/g" tmp24.txt > tmp25.txt


fi

cp tmp25.txt $CMSSW_REL.txt
rm tmp*
cp $CMSSW_REL.txt ../../Validations/.
mv $CMSSW_REL.txt backup/.
cd ../..
sh txt2html.sh
cd html_validations/Tools
