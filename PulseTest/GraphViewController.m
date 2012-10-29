//
//  GraphViewController.m
//  StressBuster
//
//  Created by Simon Tucker on 10/27/12.
//  Copyright (c) 2012 Simon Tucker. All rights reserved.
//

#import "GraphViewController.h"
#define MIN_THRESHOLD 80000
#import "User.h"
@interface GraphViewController ()

@end

@implementation GraphViewController

@synthesize brightnessValues;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // Create the chart
    chart = [[ShinobiChart alloc] initWithFrame:self.view.bounds];
    chart.title = @"My First Chart";
    chart.licenseKey = @"K463aKgV9mpa51HMjAxMjExMjZpbmZvQHNoaW5vYmljb250cm9scy5jb20=MPaex/D1Db+lAwHE5EDHeAYAq4uFjf/2QwHCXN/+BuO8+bbkLZYMiYaQPfVVT83o44H9G77YXykCp8O8d1uqE0ZLYmNugmbxeEWrnTQqipX5o5ouvpX8EeqaPMkasej99OpZyBkbtL5LCV6aelf2+xtiDHW0=BQxSUisl3BaWf/7myRmmlIjRnMU2cA7q+/03ZX9wdj30RzapYANf51ee3Pi8m2rVW6aD7t6Hi4Qy5vv9xpaQYXF5T7XzsafhzS3hbBokp36BoJZg8IrceBj742nQajYyV7trx5GIw9jy/V6r0bvctKYwTim7Kzq+YPWGMtqtQoU=PFJTQUtleVZhbHVlPjxNb2R1bHVzPnh6YlRrc2dYWWJvQUh5VGR6dkNzQXUrUVAxQnM5b2VrZUxxZVdacnRFbUx3OHZlWStBK3pteXg4NGpJbFkzT2hGdlNYbHZDSjlKVGZQTTF4S2ZweWZBVXBGeXgxRnVBMThOcDNETUxXR1JJbTJ6WXA3a1YyMEdYZGU3RnJyTHZjdGhIbW1BZ21PTTdwMFBsNWlSKzNVMDg5M1N4b2hCZlJ5RHdEeE9vdDNlMD08L01vZHVsdXM+PEV4cG9uZW50PkFRQUI8L0V4cG9uZW50PjwvUlNBS2V5VmFsdWU+";
    
    chart.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin |
    UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin;
    
    // Use a number axis for the x axis.
    SChartNumberAxis *xAxis = [[SChartNumberAxis alloc] init];
    xAxis.title = @"X-Axis";
    chart.xAxis = xAxis;

    
    // Use a number axis for the y axis.
    SChartNumberAxis *yAxis = [[SChartNumberAxis alloc] init];
    yAxis.title = @"Y-Axis";
    chart.yAxis = yAxis;

    // Show the legend
    chart.legend.hidden = YES;
    
    chart.datasource = self;
    
    // Add the chart to the view controller
    [self.view addSubview:chart];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Returns the number of series in the specified chart
- (int)numberOfSeriesInSChart:(ShinobiChart *)chart {
    return 1;
}

// Returns the series at the specified index for a given chart
-(SChartSeries *)sChart:(ShinobiChart *)chart seriesAtIndex:(int)index {
    
    // In our example all series are line series.
    SChartLineSeries *lineSeries = [[SChartLineSeries alloc] init];
    
    // Set up the series
    lineSeries.title = [NSString stringWithFormat:@"brightness"];
    lineSeries.style.lineWidth = [NSNumber numberWithInt:4];
    
    // Customise the series at index 0
    if (index == 0) {
        lineSeries.style.showFill = YES;
        lineSeries.style.areaColor = [UIColor orangeColor];
        lineSeries.style.areaColorLowGradient = [UIColor yellowColor];
    }
    
    return lineSeries;
}

// Returns the number of points for a specific series in the specified chart
- (int)sChart:(ShinobiChart *)chart numberOfDataPointsForSeriesAtIndex:(int)seriesIndex {
    if(brightnessValues)
    {
        NSLog(@"%i",[self pulseScore]);
        
        return brightnessValues.count;
    }else
    {
        return 0;
    }
}

// Returns the data point at the specified index for the given series/chart.
- (id<SChartData>)sChart:(ShinobiChart *)chart dataPointAtIndex:(int)dataIndex forSeriesAtIndex:(int)seriesIndex {
    
    //Construct a data point to return
    SChartDataPoint *datapoint = [[SChartDataPoint alloc] init];
    
    datapoint.xValue = [NSNumber numberWithDouble:dataIndex];
    datapoint.yValue = [brightnessValues objectAtIndex:dataIndex];
    
    return datapoint;
}

-(NSInteger)pulseScore
{
    float localMin = 100000000;
    float localMax = -100000000;
    float previousVal = -100000000;
    
    NSMutableArray *localMins = [[NSMutableArray alloc] init];
    NSMutableArray *localMaxes = [[NSMutableArray alloc] init];
    
    for(NSNumber *value in brightnessValues)
    {
        float val = [value floatValue];
        if(previousVal>=0)
        {
            if(val>previousVal)
            {
                if(localMin==previousVal){
                    [localMins addObject:[NSNumber numberWithFloat:localMin]];
                }
                localMax=val;
            }else
            if(val<previousVal)
            {
                if(localMax==previousVal){
                    [localMaxes addObject:[NSNumber numberWithFloat:localMax]];
                }
                localMin=val;
            }
        }else
        {
            if(val<localMin)
            {
                localMin = val;
            }
            if(val>localMax)
            {
                localMax = val;
            }
        }
        previousVal = val;
    }
    NSLog(@"the local maxes %@", localMaxes);
    NSLog(@"the local mins %@", localMins);
    
    NSLog(@"local maxes and mins count %i %i",localMaxes.count, localMins.count);
    
    [[User sharedUser] setCurrentPulse:localMins.count*2/3];
    [[[User sharedUser] locationManager] startUpdatingLocation];
    
    return localMins.count*2/3;
}
@end
