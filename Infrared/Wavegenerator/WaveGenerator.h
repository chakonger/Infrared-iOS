#ifndef __WAVE_GENERATEOR__
#define __WAVE_GENERATEOR__

#include <string>

#include <vector>
#include <stdint.h>

using namespace std;

class WaveGenerator
{
public:

    WaveGenerator(string content, double freqOfTone);
    ~WaveGenerator();
    
    vector<uint8_t> getPcmData();
    vector<uint8_t> getWaveData();

private:
    
    int genSamples(vector<uint8_t> &vec, double time/*ms*/, float percent);
    int genBlank(vector<uint8_t> &vec);
    int genPcm(vector<uint8_t> &vec);


    int mSendCount;
    int mLevelCount;
    string mContent;
    int* mLevel;
    
    int mSampleRate;
    int mNumChannel;
    int mBitsPerSample;
    double mFreqOfTone; //hz  20000=>20khz(50us) 最高
};
#endif
