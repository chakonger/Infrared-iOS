#ifndef __WAVE_HEADER__
#define __WAVE_HEADER__

#include <string>
#include <vector>
#include <stdint.h>

using namespace std;

class WaveHeader
{
public:

    static const short FORMAT_PCM;
    static const short FORMAT_ALAW;
    static const short FORMAT_ULAW;

    WaveHeader(short format, short numChannels, int sampleRate, short bitsPersamples,  int numBytes):mFormat(format),mNumChannels(numChannels),mSampleRate(sampleRate),mBitsPerSample(bitsPersamples),mNumBytes(numBytes) {}
    ~WaveHeader(){}
    vector<uint8_t> getWaveHeader();

private:
    
    int AddString(vector<uint8_t> &vec, string str);
    int AddInt(vector<uint8_t> &vec, int val);
    int AddShort(vector<uint8_t> &vec, short val);

    short mFormat;
    short mNumChannels;
    int mSampleRate;
    short mBitsPerSample;
    int mNumBytes;
};

#endif
