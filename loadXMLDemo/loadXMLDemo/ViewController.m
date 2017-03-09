//
//  ViewController.m
//  loadXMLDemo
//
//  Created by 梁家伟 on 17/3/9.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "ViewController.h"
#import "Video.h"


@interface ViewController ()<NSXMLParserDelegate>
@property(nonatomic,strong)NSMutableArray* videosArray;
@property(nonatomic,strong)NSMutableString* content;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.videosArray = [NSMutableArray array];
    [self loadXMLData];
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadXMLData{
    
//    NSURL* url = [NSURL URLWithString:@"http://127.0.0.1/videos01.xml"];
    NSURL* url = [NSURL URLWithString:@"http://127.0.0.1/videos02.xml"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"%@", error);
            return;
        }
        
        //创建xml的解析器
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
        //设置解析器的代码
        parser.delegate = self;
        //开始解析
        [parser parse];
        
    }] resume];
    
}






-(void)parserDidStartDocument:(NSXMLParser *)parser{


    NSLog(@"1.开始解析文档");

}


-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict{

    NSLog(@"2.%@",elementName);

    if([elementName isEqualToString:@"video"]){

        Video* video = [Video new];

        for (NSString* key in attributeDict) {
            [video setValue:attributeDict[key] forKey:key];
        }

        _content = [NSMutableString string];
        
        [self.videosArray addObject:video];
    }

}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    
    //拼接
    [_content appendString: string];
}


-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
    if(![elementName isEqualToString:@"video"] && ![elementName isEqualToString:@"videos"]){
        
        Video* video = _videosArray.lastObject;
        
        [video setValue:_content forKey:elementName];
        
    }
}





-(void)parserDidEndDocument:(NSXMLParser *)parser{

    NSLog(@"4.结束解析文档");
    NSLog(@"%@",self.videosArray);
}






















//videos01.xml
//-(void)parserDidStartDocument:(NSXMLParser *)parser{
//    
//    
//    NSLog(@"1.开始解析文档");
//    
//}
//
//
//-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict{
//    
//    NSLog(@"2.%@",elementName);
//    
//    if([elementName isEqualToString:@"video"]){
//        
//        Video* video = [Video new];
//        
//        for (NSString* key in attributeDict) {
//            [video setValue:attributeDict[key] forKey:key];
//        }
//        
//        [self.videosArray addObject:video];
//    }
//   
//}
//
//
//-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
//    
//    NSLog(@"3.%@",elementName);
//}
//
//
//-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
//    
//    
//    NSLog(@"%s   %@",__FUNCTION__,string);
//    
//}
//
//
//-(void)parserDidEndDocument:(NSXMLParser *)parser{
//    
//    NSLog(@"4.结束解析文档");
//    NSLog(@"%@",self.videosArray);
//}

@end
