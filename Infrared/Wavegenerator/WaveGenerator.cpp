/*
 * Copyright (C) 2015 myfaxmail@163.com
 */
//可改变频率

#include <stdlib.h>
#include <math.h>
#include <stdio.h>

#include "WaveGenerator.h"
#include "WaveHeader.h"

WaveGenerator::WaveGenerator(string content, double freqOfTone):mSendCount(1),mLevelCount(1),mContent(content), mSampleRate(44100),mNumChannel(2),mBitsPerSample(16),mFreqOfTone(20000)//mFreOfTone是修改频率的
{
    if (freqOfTone > 200)
        mFreqOfTone = freqOfTone;

    if (content.length() == 0) {
        return;
    }

    mSendCount = (int)  strtol(content.substr(0, 2).c_str(), NULL, 16);
    mLevelCount = (int) strtol(content.substr(2, 4).c_str(), NULL, 16);
    mLevel = new int[mLevelCount];
    int len = (int)content.length();
      // printf("%s",content.c_str());
    for (int i = 6, j = 0; i < len && j < mLevelCount; i += 4, j++) {
        
        mLevel[j] = (int) strtol(content.substr(i, 4).c_str(), NULL, 16);
        printf("%d\n",mLevel[j]);
        
    }
    
}

WaveGenerator::~WaveGenerator()
{
    delete mLevel;
}

/*
int WaveGenerator::getPcmSize()
{

}
uint8_t *WaveGenerator::getPcmData()
{

}
*/

vector<uint8_t> WaveGenerator::getPcmData()
{
    vector<uint8_t> vec;
    
    vec.clear();
    for (int i = 0; i < mSendCount; i++) {
        genBlank(vec);
        genPcm(vec);
        genBlank(vec);
    }

    return vec;
}
/*
int WaveGenerator::getWaveSize()
{
}
uint8_t *WaveGenerator::getWaveData()
{

}
*/

vector<uint8_t> WaveGenerator::getWaveData()
{
    vector<uint8_t> vec, headerVec, PcmVec;

    vec.clear();
    headerVec.clear();
    PcmVec.clear();
    
    PcmVec = getPcmData();
    WaveHeader header(WaveHeader::FORMAT_PCM, mNumChannel, mSampleRate, mBitsPerSample, (int)PcmVec.size());
    headerVec = header.getWaveHeader();

    printf("headersize = %ld\n", headerVec.size());
    printf("pcmdatasize = %ld\n", PcmVec.size());
    vec.insert(vec.end(), headerVec.begin(), headerVec.end());
    vec.insert(vec.end(), PcmVec.begin(), PcmVec.end());

    return vec;
}

int WaveGenerator::genSamples(vector<uint8_t> &vec, double time/*ms*/, float percent)
{
    int numSamples = ((int) (time * mSampleRate / 1000) ) * 2;
    double *sample = (double *)malloc(numSamples * sizeof(double));

    // generate the dual-channel sampling.
    // y=Asin（ωx+φ）+h
    for (int i = 0; i < numSamples / 2; i++) {
        sample[i * 2] = sin(2 * M_PI * i / (mSampleRate/mFreqOfTone));
        sample[i * 2 + 1] = 0 - sample[i * 2];
    }
    
    for (int i = 0; i < numSamples; i++) {
        short val = (short)(sample[i] * 32767 * percent);
        vec.push_back((uint8_t) (val & 0x00ff));
        vec.push_back((uint8_t) ((val & 0xff00) >> 8));
    }

    free(sample);
    return 0;
}

int WaveGenerator::genBlank(vector<uint8_t> &vec)
{
    for(int i = 0; i < 10; ++i) {
        genSamples(vec, 10, 0);         // 10ms 0

        for(int j = 1; j < 4; ++j) {
            genSamples(vec, 2.25 - 0.56, 0.08f);
            genSamples(vec, 0.56, 0);
        }

        genSamples(vec, 10, 0);         // 10ms 0
    }
    return 0;
}

int WaveGenerator::genPcm(vector<uint8_t> &vec)
{
    for(int i = 0; i < mLevelCount; i += 2 ) {
        genSamples(vec, ((double)(mLevel[i]))/1000.0, 1);
        genSamples(vec, ((double)(mLevel[i+1]))/1000.0, 0);
    }

    return 0;
}
