/*
 * Copyright (C) 2015 myfaxmail@163.com
 */

#include <string>
#include "WaveHeader.h" 

const short WaveHeader::FORMAT_PCM = 1;
const short WaveHeader::FORMAT_ALAW = 6;
const short WaveHeader::FORMAT_ULAW = 7;

vector<uint8_t> WaveHeader::getWaveHeader()
{
    vector<uint8_t> vec;

    vec.clear();
    
    /* RIFF header */
    AddString(vec, string("RIFF"));
    AddInt(vec, 36 + mNumBytes);
    AddString(vec, string("WAVE"));

    /* fmt chunk */
    AddString(vec, string("fmt "));
    AddInt(vec, 16);
    AddShort(vec, mFormat);
    AddShort(vec, mNumChannels);
    AddInt(vec, mSampleRate);
    AddInt(vec, mNumChannels * mSampleRate * mBitsPerSample / 8);
    AddShort(vec, (short)(mNumChannels * mBitsPerSample / 8));
    AddShort(vec, mBitsPerSample);

    /* data chunk */
    AddString(vec, string("data"));
    AddInt(vec, mNumBytes);

    return vec;

}
int WaveHeader::AddString(vector<uint8_t> &vec, string str)
{
    ;
    
    for(string::iterator itstr = str.begin(); itstr != str.end( ); ++itstr) {
        vec.push_back((uint8_t)(*itstr));
    }

    return 0;
}

int WaveHeader::AddInt(vector<uint8_t> &vec, int val)
{
    vec.push_back((uint8_t)((val >> 0) & 0xff));
    vec.push_back((uint8_t)((val >> 8) & 0xff));
    vec.push_back((uint8_t)((val >> 16) & 0xff));
    vec.push_back((uint8_t)((val >> 24) & 0xff));

    return 0;
}

int WaveHeader::AddShort(vector<uint8_t> &vec, short val)
{
    vec.push_back((uint8_t)((val >> 0) & 0xff));
    vec.push_back((uint8_t)((val >> 8) & 0xff));
    
    return 0;
}

