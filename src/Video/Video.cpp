#include "Font.h"
Mutex VideoBufferMutex;

class Video
{
public:
	unsigned short Width;
	unsigned short Height;
	unsigned char Depth;
	unsigned short BytesPerLine;
	unsigned char MemoryModel;
	unsigned short ModeAttributes;
	unsigned char RedMaskSize;
	unsigned char RedFieldPos;
	unsigned char GreenMaskSize;
	unsigned char GreenFieldPos;
	unsigned char BlueMaskSize;
	unsigned char BlueFieldPos;
	unsigned char RSVDMaskSize;
	unsigned char RSVDFieldPos;
	
	unsigned char* FrameAddress;
	unsigned char* SecondFrameAddress;
	
	unsigned char* operator()(unsigned int, unsigned int);
	void DrawPixel(unsigned int, unsigned int, unsigned char, unsigned char, unsigned char);
	void DrawRect(unsigned int, unsigned int, unsigned int, unsigned int, unsigned char, unsigned char, unsigned char);
	void Update();
	Video(vbe_mode_info_struct*);
	Video();
};

unsigned char* Video::operator()(unsigned int x, unsigned int y)
{
	return (SecondFrameAddress + ((y * BytesPerLine) + (x * Depth)));
}

void Video::Update()
{
	VideoBufferMutex.Lock();
	char* NewFrame = (char*)SecondFrameAddress;
	char* MainFrame = (char*)FrameAddress;
	for(int i = 0; i < Height; i++)
	{
		for(int j = 0; j < Width*3; j++)
		{
			int pos = (i * BytesPerLine) + j;
			MainFrame[pos] = NewFrame[pos];
		}
	}
	VideoBufferMutex.Unlock();
}

Video::Video()
{}

Video::Video(vbe_mode_info_struct* Video_data)
{
	Width = Video_data->XRes;
	Height = Video_data->YRes;
	Depth = Video_data->BitsPerPixel / 8;
	FrameAddress = (unsigned char*)((long)Video_data->PhysBasePtr);
	BytesPerLine = Video_data->BytesPerScanLine;
	MemoryModel = Video_data->MemoryModel;
	ModeAttributes = Video_data->ModeAttr;
	RedMaskSize = Video_data->RedMaskSize;
	RedFieldPos = Video_data->RedFieldPos;
	GreenMaskSize = Video_data->GreenMaskSize;
	GreenFieldPos = Video_data->GreenFieldPos;
	BlueMaskSize = Video_data->BlueMaskSize;
	BlueFieldPos = Video_data->BlueFieldPos;
	RSVDMaskSize = Video_data->RSVDMaskSize;
	RSVDFieldPos = Video_data->RSVDFieldPos;
}

Video GUI;
